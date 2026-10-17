package wallet

import (
	"context"
	"errors"
	"strings"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/provider"
)

const (
	nameMaxLen = 30

	// cashProviderSlug is the provider of the Cash wallet created on register.
	cashProviderSlug = "cash"
	cashWalletName   = "Cash"
)

// PaymentProviders is the part of the provider feature the service uses, so a
// test fake implements two methods instead of the whole repository. module.go
// adapts provider.Repository to it.
type PaymentProviders interface {
	FindByID(ctx context.Context, id uuid.UUID) (*provider.PaymentProvider, error)
	FindBySlug(ctx context.Context, slug string) (*provider.PaymentProvider, error)
}

type Service interface {
	// List returns the user's wallets and the total balance of the
	// non-archived ones.
	List(ctx context.Context, userID uuid.UUID, q ListWalletsQuery) ([]WalletResponse, WalletListMeta, error)
	Get(ctx context.Context, userID, id uuid.UUID) (WalletResponse, error)
	// Create adds a wallet, from an active provider or custom. A new default
	// clears the old one in the same DB transaction.
	Create(ctx context.Context, userID uuid.UUID, req CreateWalletRequest) (WalletResponse, error)
	// Update applies the fields present in req. The default wallet cannot be
	// archived or unset; set another wallet as default instead.
	Update(ctx context.Context, userID, id uuid.UUID, req UpdateWalletRequest) (WalletResponse, error)
	// Delete removes a non-default wallet that has never had transactions.
	Delete(ctx context.Context, userID, id uuid.UUID) error
	// SeedDefault creates the default Cash wallet for a new user. Call it
	// inside the register transaction.
	SeedDefault(ctx context.Context, userID uuid.UUID) error
}

type service struct {
	repo      Repository
	providers PaymentProviders
	tx        database.TxManager
	logoURL   logoURLFunc // public URL of a provider logo key
}

func NewService(
	repo Repository,
	providers PaymentProviders,
	tx database.TxManager,
	store storage.Storage,
	cfg config.Config,
) Service {
	return &service{
		repo:      repo,
		providers: providers,
		tx:        tx,
		logoURL:   storage.NullablePublicURL(store, cfg.MinIO.BucketPublic),
	}
}

func (s *service) List(ctx context.Context, userID uuid.UUID, q ListWalletsQuery) ([]WalletResponse, WalletListMeta, error) {
	ds, err := s.repo.List(ctx, userID, q.IncludeArchived)
	if err != nil {
		return nil, WalletListMeta{}, err
	}

	var meta WalletListMeta
	for _, d := range ds {
		if !d.IsArchived {
			meta.TotalBalance += d.CurrentBalance
		}
	}

	return ToWalletResponses(ds, s.logoURL), meta, nil
}

func (s *service) Get(ctx context.Context, userID, id uuid.UUID) (WalletResponse, error) {
	d, err := s.repo.FindDetailByID(ctx, userID, id)
	if err != nil {
		return WalletResponse{}, err
	}

	return ToWalletResponse(d, s.logoURL), nil
}

func (s *service) Create(ctx context.Context, userID uuid.UUID, req CreateWalletRequest) (WalletResponse, error) {
	w := &Wallet{
		UserID:         userID,
		ProviderID:     req.ProviderID,
		InitialBalance: req.InitialBalance,
		Icon:           req.Icon,
		Color:          req.Color,
		IsDefault:      req.IsDefault,
	}
	if err := s.applyNameAndType(ctx, w, req); err != nil {
		return WalletResponse{}, err
	}

	var resp WalletResponse
	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		if w.IsDefault {
			if err := s.repo.ClearDefault(ctx, userID); err != nil {
				return err
			}
		}
		if err := s.repo.Create(ctx, w); err != nil {
			return err
		}

		var err error
		resp, err = s.Get(ctx, userID, w.ID)
		return err
	})

	return resp, err
}

func (s *service) Update(ctx context.Context, userID, id uuid.UUID, req UpdateWalletRequest) (WalletResponse, error) {
	if req.empty() {
		return WalletResponse{}, httpx.ErrNoFields
	}

	var resp WalletResponse
	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		w, err := s.repo.FindByIDForUpdate(ctx, userID, id)
		if err != nil {
			return err
		}
		wasDefault := w.IsDefault

		if err := applyUpdate(w, req); err != nil {
			return err
		}

		if w.IsDefault && !wasDefault {
			if err := s.repo.ClearDefault(ctx, userID); err != nil {
				return err
			}
		}
		if err := s.repo.Update(ctx, w); err != nil {
			return err
		}

		resp, err = s.Get(ctx, userID, id)
		return err
	})

	return resp, err
}

func (s *service) Delete(ctx context.Context, userID, id uuid.UUID) error {
	return s.tx.WithinTx(ctx, func(ctx context.Context) error {
		w, err := s.repo.FindByIDForUpdate(ctx, userID, id)
		if err != nil {
			return err
		}
		if w.IsDefault {
			return ErrDeleteDefault
		}

		has, err := s.repo.HasTransactions(ctx, id)
		if err != nil {
			return err
		}
		if has {
			return ErrHasTransactions
		}

		return s.repo.Delete(ctx, userID, id)
	})
}

func (s *service) SeedDefault(ctx context.Context, userID uuid.UUID) error {
	w := &Wallet{
		UserID:    userID,
		Name:      cashWalletName,
		Type:      TypeCash,
		IsDefault: true,
	}

	// Without the cash provider the wallet is still created, as a custom one.
	p, err := s.providers.FindBySlug(ctx, cashProviderSlug)
	switch {
	case err == nil:
		w.ProviderID = &p.ID
	case !errors.Is(err, provider.ErrNotFound):
		return err
	}

	return s.repo.Create(ctx, w)
}

// applyNameAndType sets w's name and type from req, defaulting to the
// provider's values when req.ProviderID is set. The provider must exist and
// be active.
func (s *service) applyNameAndType(ctx context.Context, w *Wallet, req CreateWalletRequest) error {
	if req.Name != nil {
		w.Name = strings.TrimSpace(*req.Name)
	}
	if req.Type != nil {
		w.Type = *req.Type
	}

	if req.ProviderID == nil {
		if w.Name == "" {
			return ErrNameBlank
		}
		if w.Type == "" {
			return ErrTypeRequired
		}
		return nil
	}

	p, err := s.providers.FindByID(ctx, *req.ProviderID)
	if errors.Is(err, provider.ErrNotFound) {
		return ErrProviderInvalid
	}
	if err != nil {
		return err
	}
	if !p.IsActive {
		return ErrProviderInvalid
	}

	if w.Name == "" {
		w.Name = truncate(p.Name, nameMaxLen)
	}
	if w.Type == "" {
		w.Type = Type(p.Type)
	}

	return nil
}

// applyUpdate applies the fields present in req to w and checks the default
// and archive rules against the resulting state.
func applyUpdate(w *Wallet, req UpdateWalletRequest) error {
	if req.Name != nil {
		w.Name = strings.TrimSpace(*req.Name)
	}
	if req.Type != nil {
		w.Type = *req.Type
	}
	if req.InitialBalance != nil {
		w.InitialBalance = *req.InitialBalance
	}
	if req.Icon.Set {
		w.Icon = req.Icon.Value
	}
	if req.Color.Set {
		w.Color = req.Color.Value
	}
	if req.IsArchived != nil {
		w.IsArchived = *req.IsArchived
	}
	if req.IsDefault != nil {
		// Only true is accepted on the default: unsetting it would leave the
		// user without one.
		if !*req.IsDefault && w.IsDefault {
			return ErrDefaultRequired
		}
		if *req.IsDefault {
			w.IsDefault = true
		}
	}

	// Archiving in this request blames the archive; otherwise the wallet was
	// already archived and is being made the default.
	if w.IsDefault && w.IsArchived {
		if req.IsArchived != nil {
			return ErrArchiveDefault
		}
		return ErrArchived
	}

	return nil
}

// truncate cuts s to at most n runes.
func truncate(s string, n int) string {
	r := []rune(s)
	if len(r) <= n {
		return s
	}
	return strings.TrimSpace(string(r[:n]))
}
