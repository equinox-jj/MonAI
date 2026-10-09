package provider

import (
	"context"
	"errors"
	"regexp"
	"slices"
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
)

// Logo upload limits (ERD §7: expense-public, providers/{provider_id}/…).
const (
	logoMaxBytes  = 512 << 10
	logoUploadTTL = 15 * time.Minute
)

// logoExtensions maps the allowed logo content types to their file extension.
var logoExtensions = map[string]string{
	"image/png":     "png",
	"image/webp":    "webp",
	"image/svg+xml": "svg",
}

const slugMaxLen = 50

var (
	slugPattern  = regexp.MustCompile(`^[a-z0-9]+(-[a-z0-9]+)*$`)
	slugSplitter = regexp.MustCompile(`[^a-z0-9]+`)
)

type Service interface {
	// CatalogVersion returns the catalog version, so the handler can answer
	// If-None-Match with 304 without loading the catalog.
	CatalogVersion(ctx context.Context) (int64, error)
	// Catalog returns the active providers and the catalog version.
	Catalog(ctx context.Context) (ProviderCatalogResponse, error)
	List(ctx context.Context, q ListProvidersQuery) ([]AdminProviderResponse, httpx.PageMeta, error)
	Get(ctx context.Context, id uuid.UUID) (AdminProviderResponse, error)
	Create(ctx context.Context, actorID uuid.UUID, req CreateProviderRequest) (AdminProviderResponse, error)
	// Update applies the fields present in req. The slug of a system
	// provider cannot be changed.
	Update(ctx context.Context, actorID, id uuid.UUID, req UpdateProviderRequest) (AdminProviderResponse, error)
	// SetStatus activates or deactivates a provider. System providers cannot
	// be deactivated.
	SetStatus(ctx context.Context, actorID, id uuid.UUID, isActive bool) (AdminProviderResponse, error)
	// Delete soft-deletes a non-system provider and removes its aliases. The
	// logo stays in storage.
	Delete(ctx context.Context, id uuid.UUID) error
	// CreateLogoUploadURL presigns a PUT for a new logo of the provider.
	CreateLogoUploadURL(ctx context.Context, id uuid.UUID, req UploadURLRequest) (UploadURLResponse, error)
	// ConfirmLogo checks the uploaded object and sets it as the provider's
	// logo.
	ConfirmLogo(ctx context.Context, actorID, id uuid.UUID, req ConfirmUploadRequest) (AdminProviderResponse, error)
}

type service struct {
	repo   Repository
	tx     database.TxManager
	store  storage.Storage
	bucket string
}

func NewService(repo Repository, tx database.TxManager, store storage.Storage, cfg config.Config) Service {
	return &service{repo: repo, tx: tx, store: store, bucket: cfg.MinIO.BucketPublic}
}

func (s *service) CatalogVersion(ctx context.Context) (int64, error) {
	return s.repo.CatalogVersion(ctx)
}

func (s *service) Catalog(ctx context.Context) (ProviderCatalogResponse, error) {
	// Read the version first: a change landing in between then pairs a newer
	// list with an older version, which the client just refetches. The other
	// order would cache a stale list under the new version.
	version, err := s.repo.CatalogVersion(ctx)
	if err != nil {
		return ProviderCatalogResponse{}, err
	}

	ps, err := s.repo.ListActive(ctx)
	if err != nil {
		return ProviderCatalogResponse{}, err
	}

	return ProviderCatalogResponse{
		Version:   version,
		Providers: ToProviderResponses(ps, s.logoURL),
	}, nil
}

func (s *service) List(ctx context.Context, q ListProvidersQuery) ([]AdminProviderResponse, httpx.PageMeta, error) {
	page := httpx.NewPageMeta(q.Page, q.PerPage, 0)

	filter := ListFilter{
		Query:  strings.TrimSpace(q.Q),
		Type:   q.Type,
		Offset: page.Offset(),
		Limit:  page.PerPage,
	}
	switch q.Status {
	case StatusActive:
		filter.IsActive = new(true)
	case StatusInactive:
		filter.IsActive = new(false)
	}

	ps, total, err := s.repo.List(ctx, filter)
	if err != nil {
		return nil, httpx.PageMeta{}, err
	}

	return ToAdminProviderResponses(ps, s.logoURL), httpx.NewPageMeta(page.Page, page.PerPage, total), nil
}

func (s *service) Get(ctx context.Context, id uuid.UUID) (AdminProviderResponse, error) {
	p, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return AdminProviderResponse{}, err
	}

	return ToAdminProviderResponse(p, s.logoURL), nil
}

func (s *service) Create(ctx context.Context, actorID uuid.UUID, req CreateProviderRequest) (AdminProviderResponse, error) {
	name := strings.TrimSpace(req.Name)
	if name == "" {
		return AdminProviderResponse{}, ErrNameBlank
	}

	var slug string
	if req.Slug != nil {
		slug = *req.Slug
	} else {
		slug = slugify(name)
	}
	if !slugPattern.MatchString(slug) {
		return AdminProviderResponse{}, ErrSlugInvalid
	}

	aliases, err := cleanAliases(req.Aliases)
	if err != nil {
		return AdminProviderResponse{}, err
	}

	p := &PaymentProvider{
		Slug:      slug,
		Name:      name,
		Type:      req.Type,
		SortOrder: req.SortOrder,
		IsActive:  true,
		CreatedBy: &actorID,
		UpdatedBy: &actorID,
	}
	err = s.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.repo.Create(ctx, p); err != nil {
			return err
		}
		if err := s.repo.ReplaceAliases(ctx, p.ID, aliases); err != nil {
			return err
		}
		return s.repo.BumpCatalogVersion(ctx)
	})
	if err != nil {
		return AdminProviderResponse{}, err
	}

	p.Aliases = toAliasRows(p.ID, aliases)
	return ToAdminProviderResponse(p, s.logoURL), nil
}

func (s *service) Update(ctx context.Context, actorID, id uuid.UUID, req UpdateProviderRequest) (AdminProviderResponse, error) {
	if req.empty() {
		return AdminProviderResponse{}, ErrNoFields
	}

	var name string
	if req.Name != nil {
		name = strings.TrimSpace(*req.Name)
		if name == "" {
			return AdminProviderResponse{}, ErrNameBlank
		}
	}
	if req.Slug != nil && !slugPattern.MatchString(*req.Slug) {
		return AdminProviderResponse{}, ErrSlugInvalid
	}
	var aliases []string
	if req.Aliases != nil {
		var err error
		if aliases, err = cleanAliases(*req.Aliases); err != nil {
			return AdminProviderResponse{}, err
		}
	}

	return s.mutate(ctx, actorID, id, func(ctx context.Context, p *PaymentProvider) error {
		if req.Slug != nil && *req.Slug != p.Slug {
			// Register finds the Cash provider by its slug.
			if p.IsSystem {
				return ErrSlugSystem
			}
			p.Slug = *req.Slug
		}
		if req.Name != nil {
			p.Name = name
		}
		if req.Type != nil {
			p.Type = *req.Type
		}
		if req.SortOrder != nil {
			p.SortOrder = *req.SortOrder
		}
		if req.Aliases != nil {
			if err := s.repo.ReplaceAliases(ctx, p.ID, aliases); err != nil {
				return err
			}
			p.Aliases = toAliasRows(p.ID, aliases)
		}
		return nil
	})
}

func (s *service) SetStatus(ctx context.Context, actorID, id uuid.UUID, isActive bool) (AdminProviderResponse, error) {
	return s.mutate(ctx, actorID, id, func(_ context.Context, p *PaymentProvider) error {
		if !isActive && p.IsSystem {
			return ErrDeactivateSystem
		}
		p.IsActive = isActive
		return nil
	})
}

func (s *service) Delete(ctx context.Context, id uuid.UUID) error {
	return s.tx.WithinTx(ctx, func(ctx context.Context) error {
		p, err := s.repo.FindByID(ctx, id)
		if err != nil {
			return err
		}
		if p.IsSystem {
			return ErrDeleteSystem
		}

		if err := s.repo.ReplaceAliases(ctx, id, nil); err != nil {
			return err
		}
		if err := s.repo.Delete(ctx, id); err != nil {
			return err
		}
		return s.repo.BumpCatalogVersion(ctx)
	})
}

func (s *service) CreateLogoUploadURL(ctx context.Context, id uuid.UUID, req UploadURLRequest) (UploadURLResponse, error) {
	ext, ok := logoExtensions[req.ContentType]
	if !ok {
		return UploadURLResponse{}, ErrContentType
	}
	if req.SizeBytes > logoMaxBytes {
		return UploadURLResponse{}, ErrFileTooLarge
	}

	if _, err := s.repo.FindByID(ctx, id); err != nil {
		return UploadURLResponse{}, err
	}

	key := logoPrefix(id) + uuid.NewString() + "." + ext
	url, err := s.store.PresignPut(ctx, s.bucket, key, logoUploadTTL)
	if err != nil {
		return UploadURLResponse{}, err
	}

	return UploadURLResponse{
		UploadURL: url,
		Method:    "PUT",
		Headers:   map[string]string{"Content-Type": req.ContentType},
		ObjectKey: key,
		ExpiresIn: int(logoUploadTTL.Seconds()),
	}, nil
}

func (s *service) ConfirmLogo(ctx context.Context, actorID, id uuid.UUID, req ConfirmUploadRequest) (AdminProviderResponse, error) {
	if !strings.HasPrefix(req.ObjectKey, logoPrefix(id)) {
		return AdminProviderResponse{}, ErrObjectKeyInvalid
	}

	// A presigned PUT does not enforce type or size, so check what landed.
	info, err := s.store.Stat(ctx, s.bucket, req.ObjectKey)
	if errors.Is(err, storage.ErrObjectNotFound) {
		return AdminProviderResponse{}, ErrObjectKeyInvalid
	}
	if err != nil {
		return AdminProviderResponse{}, err
	}
	if _, ok := logoExtensions[info.ContentType]; !ok || info.Size > logoMaxBytes {
		return AdminProviderResponse{}, ErrObjectKeyInvalid
	}

	return s.mutate(ctx, actorID, id, func(_ context.Context, p *PaymentProvider) error {
		p.LogoKey = &req.ObjectKey
		return nil
	})
}

// mutate loads the provider, applies fn, then saves it as updated by actorID
// and bumps the catalog version, all in one DB transaction.
func (s *service) mutate(
	ctx context.Context,
	actorID, id uuid.UUID,
	fn func(ctx context.Context, p *PaymentProvider) error,
) (AdminProviderResponse, error) {
	var p *PaymentProvider
	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		if p, err = s.repo.FindByID(ctx, id); err != nil {
			return err
		}
		if err := fn(ctx, p); err != nil {
			return err
		}

		p.UpdatedBy = &actorID
		if err := s.repo.Update(ctx, p); err != nil {
			return err
		}
		return s.repo.BumpCatalogVersion(ctx)
	})
	if err != nil {
		return AdminProviderResponse{}, err
	}

	return ToAdminProviderResponse(p, s.logoURL), nil
}

func (s *service) logoURL(key *string) *string {
	if key == nil {
		return nil
	}
	url := s.store.PublicURL(s.bucket, *key)
	return &url
}

func logoPrefix(id uuid.UUID) string {
	return "providers/" + id.String() + "/"
}

// slugify derives a slug from a name: lowercase, runs of other characters
// become one hyphen, at most slugMaxLen characters. It returns "" when the
// name has no letters or digits.
func slugify(name string) string {
	slug := strings.Trim(slugSplitter.ReplaceAllString(strings.ToLower(name), "-"), "-")
	if len(slug) > slugMaxLen {
		slug = strings.TrimRight(slug[:slugMaxLen], "-")
	}
	return slug
}

// cleanAliases trims, lowercases, sorts and dedupes aliases, matching the
// repository's alias order. It never returns nil.
func cleanAliases(aliases []string) ([]string, error) {
	out := make([]string, len(aliases))
	for i, a := range aliases {
		out[i] = strings.ToLower(strings.TrimSpace(a))
		if out[i] == "" {
			return nil, ErrAliasBlank
		}
	}
	slices.Sort(out)
	return slices.Compact(out), nil
}

func toAliasRows(id uuid.UUID, aliases []string) []ProviderAlias {
	rows := make([]ProviderAlias, len(aliases))
	for i, a := range aliases {
		rows[i] = ProviderAlias{Alias: a, ProviderID: id}
	}
	return rows
}
