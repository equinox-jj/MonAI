package provider

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

const (
	slugUniqueIndex = "payment_providers_slug_active"
	aliasPrimaryKey = "provider_aliases_pkey"
)

// orderBy is the catalog order for both the public and the admin lists.
const orderBy = "sort_order, lower(name)"

// ListFilter narrows List. An empty Query and nil fields don't filter.
type ListFilter struct {
	// Query matches name or slug, case-insensitive substring.
	Query string
	// IsActive nil returns both active and inactive providers.
	IsActive *bool
	Type     *Type
	Offset   int
	Limit    int
}

type Repository interface {
	// ListActive returns the active providers with their aliases, ordered by
	// sort_order, then name (case-insensitive). It never returns nil.
	ListActive(ctx context.Context) ([]PaymentProvider, error)
	// ActiveAliases returns the aliases of the given providers that are active,
	// keyed by provider ID and sorted. Unknown or inactive IDs are left out.
	ActiveAliases(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID][]string, error)
	// List returns one page of providers, active and inactive, with their
	// aliases, plus the total count matching filter. It never returns nil.
	List(ctx context.Context, filter ListFilter) ([]PaymentProvider, int64, error)
	// FindByID returns the provider with its aliases, or ErrNotFound when the
	// row is missing or soft-deleted.
	FindByID(ctx context.Context, id uuid.UUID) (*PaymentProvider, error)
	// FindByIDForUpdate is FindByID that also locks the provider row until
	// the transaction in ctx ends. Call it inside TxManager.WithinTx.
	FindByIDForUpdate(ctx context.Context, id uuid.UUID) (*PaymentProvider, error)
	// FindBySlug returns the provider with its aliases, or ErrNotFound when no
	// non-deleted provider has slug. Register uses it for the Cash wallet.
	FindBySlug(ctx context.Context, slug string) (*PaymentProvider, error)
	// Create inserts p without its aliases (use ReplaceAliases) and fills its
	// ID and timestamps.
	Create(ctx context.Context, p *PaymentProvider) error
	// Update writes p's editable fields and refreshes p from the updated row.
	// Aliases are not touched (use ReplaceAliases).
	Update(ctx context.Context, p *PaymentProvider) error
	// Delete soft-deletes the provider. Run it with ReplaceAliases(id, nil)
	// and BumpCatalogVersion inside TxManager.WithinTx.
	Delete(ctx context.Context, id uuid.UUID) error
	// ReplaceAliases deletes the provider's aliases and inserts aliases, which
	// the service has already lowercased. Empty aliases only deletes.
	ReplaceAliases(ctx context.Context, id uuid.UUID, aliases []string) error
	// CatalogVersion returns the current payment provider catalog version.
	CatalogVersion(ctx context.Context) (int64, error)
	// BumpCatalogVersion increments the catalog version. Call it in the same
	// transaction as every provider change.
	BumpCatalogVersion(ctx context.Context) error
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) ListActive(ctx context.Context) ([]PaymentProvider, error) {
	ps := []PaymentProvider{}
	if err := withAliases(database.Conn(ctx, r.db)).
		Where("is_active").
		Order(orderBy).
		Find(&ps).Error; err != nil {
		return nil, err
	}

	return normalizeAliases(ps), nil
}

func (r *repository) ActiveAliases(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID][]string, error) {
	out := make(map[uuid.UUID][]string)
	if len(ids) == 0 {
		return out, nil
	}

	var rows []ProviderAlias
	if err := database.Conn(ctx, r.db).
		Table("provider_aliases a").
		Select("a.alias, a.provider_id").
		Joins("JOIN payment_providers p ON p.id = a.provider_id AND p.is_active AND p.deleted_at IS NULL").
		Where("a.provider_id IN ?", ids).
		Order("a.alias").
		Scan(&rows).Error; err != nil {
		return nil, err
	}
	for _, a := range rows {
		out[a.ProviderID] = append(out[a.ProviderID], a.Alias)
	}

	return out, nil
}

func (r *repository) List(ctx context.Context, filter ListFilter) ([]PaymentProvider, int64, error) {
	var total int64
	if err := database.Conn(ctx, r.db).
		Model(&PaymentProvider{}).
		Scopes(filter.scope).
		Count(&total).Error; err != nil {
		return nil, 0, err
	}

	ps := []PaymentProvider{}
	if err := withAliases(database.Conn(ctx, r.db)).
		Scopes(filter.scope).
		Order(orderBy).
		Offset(filter.Offset).
		Limit(filter.Limit).
		Find(&ps).Error; err != nil {
		return nil, 0, err
	}

	return normalizeAliases(ps), total, nil
}

func (r *repository) FindByID(ctx context.Context, id uuid.UUID) (*PaymentProvider, error) {
	return r.findOne(database.Conn(ctx, r.db), "id = ?", id)
}

func (r *repository) FindByIDForUpdate(ctx context.Context, id uuid.UUID) (*PaymentProvider, error) {
	return r.findOne(database.Conn(ctx, r.db).Clauses(database.ForUpdate), "id = ?", id)
}

func (r *repository) FindBySlug(ctx context.Context, slug string) (*PaymentProvider, error) {
	return r.findOne(database.Conn(ctx, r.db), "slug = ?", slug)
}

func (r *repository) Create(ctx context.Context, p *PaymentProvider) error {
	// Omit associations: GORM would upsert aliases with ON CONFLICT DO NOTHING
	// and silently drop the ones another provider already owns.
	if err := database.Conn(ctx, r.db).Omit(clause.Associations).Create(p).Error; err != nil {
		return slugTaken(err)
	}

	return nil
}

func (r *repository) Update(ctx context.Context, p *PaymentProvider) error {
	// A map, so a nil logo_key/updated_by becomes NULL and false is_active is
	// written.
	res := database.Conn(ctx, r.db).
		Model(p).
		Clauses(clause.Returning{}).
		Where("id = ?", p.ID).
		Updates(map[string]any{
			"name":       p.Name,
			"slug":       p.Slug,
			"type":       p.Type,
			"logo_key":   p.LogoKey,
			"sort_order": p.SortOrder,
			"is_active":  p.IsActive,
			"updated_by": p.UpdatedBy,
			"updated_at": time.Now(),
		})
	if res.Error != nil {
		return slugTaken(res.Error)
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

func (r *repository) Delete(ctx context.Context, id uuid.UUID) error {
	res := database.Conn(ctx, r.db).Delete(&PaymentProvider{}, "id = ?", id)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

func (r *repository) ReplaceAliases(ctx context.Context, id uuid.UUID, aliases []string) error {
	db := database.Conn(ctx, r.db)
	if err := db.Where("provider_id = ?", id).Delete(&ProviderAlias{}).Error; err != nil {
		return err
	}
	if len(aliases) == 0 {
		return nil
	}

	rows := make([]ProviderAlias, len(aliases))
	for i, a := range aliases {
		rows[i] = ProviderAlias{Alias: a, ProviderID: id}
	}
	if err := db.Create(&rows).Error; err != nil {
		return aliasTaken(err)
	}

	return nil
}

func (r *repository) CatalogVersion(ctx context.Context) (int64, error) {
	var cv CatalogVersion
	if err := database.Conn(ctx, r.db).
		Where("name = ?", CatalogName).
		First(&cv).Error; err != nil {
		return 0, err
	}

	return cv.Version, nil
}

func (r *repository) BumpCatalogVersion(ctx context.Context) error {
	res := database.Conn(ctx, r.db).
		Model(&CatalogVersion{}).
		Where("name = ?", CatalogName).
		UpdateColumns(map[string]any{
			"version":    gorm.Expr("version + 1"),
			"updated_at": time.Now(),
		})
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		// Seeded by migration 000003, so a missing row is a broken schema.
		return errors.New("provider: catalog_versions row missing")
	}

	return nil
}

func (r *repository) findOne(db *gorm.DB, query string, arg any) (*PaymentProvider, error) {
	var p PaymentProvider
	if err := withAliases(db).Where(query, arg).First(&p).Error; err != nil {
		return nil, database.NotFound(err, ErrNotFound)
	}
	if p.Aliases == nil {
		p.Aliases = []ProviderAlias{}
	}

	return &p, nil
}

// scope applies the filter's WHERE clauses, shared by the count and the page
// query.
func (f ListFilter) scope(q *gorm.DB) *gorm.DB {
	if f.Query != "" {
		pattern := "%" + database.EscapeLike(f.Query) + "%"
		q = q.Where("name ILIKE ? OR slug ILIKE ?", pattern, pattern)
	}
	if f.IsActive != nil {
		q = q.Where("is_active = ?", *f.IsActive)
	}
	if f.Type != nil {
		q = q.Where("type = ?", *f.Type)
	}

	return q
}

func withAliases(q *gorm.DB) *gorm.DB {
	return q.Preload("Aliases", func(db *gorm.DB) *gorm.DB {
		return db.Order("alias")
	})
}

// normalizeAliases replaces nil alias slices so DTOs serialize them as [].
func normalizeAliases(ps []PaymentProvider) []PaymentProvider {
	for i := range ps {
		if ps[i].Aliases == nil {
			ps[i].Aliases = []ProviderAlias{}
		}
	}

	return ps
}

func slugTaken(err error) error {
	if database.IsUniqueViolation(err, slugUniqueIndex) {
		return ErrSlugTaken
	}

	return err
}

func aliasTaken(err error) error {
	if database.IsUniqueViolation(err, aliasPrimaryKey) {
		return ErrAliasTaken
	}

	return err
}
