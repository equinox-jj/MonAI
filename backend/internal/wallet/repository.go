package wallet

import (
	"context"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

const (
	nameUniqueIndex    = "wallets_user_name"
	defaultUniqueIndex = "wallets_one_default"
)

// balanceJoin sums each wallet's movements from the user's non-deleted
// transactions (ERD §2.8): income in, expense and transfers out on wallet_id,
// transfers in on to_wallet_id. Both scans are scoped to the user, so they use
// the transactions_user_date index instead of scanning every wallet's rows.
const balanceJoin = `LEFT JOIN (
		SELECT wallet_id, SUM(amount) AS delta FROM (
			SELECT wallet_id, CASE WHEN type = 'INCOME' THEN amount ELSE -amount END AS amount
			FROM transactions WHERE user_id = ? AND deleted_at IS NULL
			UNION ALL
			SELECT to_wallet_id, amount
			FROM transactions WHERE user_id = ? AND type = 'TRANSFER' AND deleted_at IS NULL
		) moves
		GROUP BY wallet_id
	) b ON b.wallet_id = w.id`

type Repository interface {
	// List returns the user's wallets with balances, default first, then
	// archived last, then name (case-insensitive). It never returns nil.
	List(ctx context.Context, userID uuid.UUID, includeArchived bool) ([]Detail, error)
	// ListActive returns the user's non-archived wallets without balances,
	// ordered by name. It never returns nil.
	ListActive(ctx context.Context, userID uuid.UUID) ([]Wallet, error)
	// FindDetailByID returns the wallet with its balance, or ErrNotFound when
	// the row is missing or belongs to another user.
	FindDetailByID(ctx context.Context, userID, id uuid.UUID) (*Detail, error)
	// FindByID returns ErrNotFound when the row is missing or belongs to
	// another user.
	FindByID(ctx context.Context, userID, id uuid.UUID) (*Wallet, error)
	// FindByIDForUpdate is FindByID that also locks the row until the
	// transaction in ctx ends. Call it inside TxManager.WithinTx.
	FindByIDForUpdate(ctx context.Context, userID, id uuid.UUID) (*Wallet, error)
	// Create inserts w and fills its ID and timestamps. Used by POST /wallets
	// and register seeding.
	Create(ctx context.Context, w *Wallet) error
	// Update writes w's editable fields, scoped to w.UserID, and refreshes w
	// from the updated row. provider_id is never changed.
	Update(ctx context.Context, w *Wallet) error
	// ClearDefault unsets the user's default wallet. Run it before setting a
	// new default inside TxManager.WithinTx (one default per user).
	ClearDefault(ctx context.Context, userID uuid.UUID) error
	Delete(ctx context.Context, userID, id uuid.UUID) error
	// HasTransactions reports whether any transaction, soft-deleted ones
	// included, uses the wallet as source or destination.
	HasTransactions(ctx context.Context, id uuid.UUID) (bool, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) List(ctx context.Context, userID uuid.UUID, includeArchived bool) ([]Detail, error) {
	q := r.detailQuery(ctx, userID)
	if !includeArchived {
		q = q.Where("NOT w.is_archived")
	}

	ds := []Detail{}
	if err := q.Order("w.is_default DESC, w.is_archived, lower(w.name)").Scan(&ds).Error; err != nil {
		return nil, err
	}

	return ds, nil
}

func (r *repository) ListActive(ctx context.Context, userID uuid.UUID) ([]Wallet, error) {
	ws := []Wallet{}
	if err := database.Conn(ctx, r.db).
		Where("user_id = ? AND NOT is_archived", userID).
		Order("lower(name)").
		Find(&ws).Error; err != nil {
		return nil, err
	}

	return ws, nil
}

func (r *repository) FindDetailByID(ctx context.Context, userID, id uuid.UUID) (*Detail, error) {
	var d Detail
	res := r.detailQuery(ctx, userID).Where("w.id = ?", id).Scan(&d)
	if res.Error != nil {
		return nil, res.Error
	}
	if res.RowsAffected == 0 {
		return nil, ErrNotFound
	}

	return &d, nil
}

func (r *repository) FindByID(ctx context.Context, userID, id uuid.UUID) (*Wallet, error) {
	return r.findByID(database.Conn(ctx, r.db), userID, id)
}

func (r *repository) FindByIDForUpdate(ctx context.Context, userID, id uuid.UUID) (*Wallet, error) {
	return r.findByID(database.Conn(ctx, r.db).Clauses(database.ForUpdate), userID, id)
}

func (r *repository) findByID(db *gorm.DB, userID, id uuid.UUID) (*Wallet, error) {
	var w Wallet
	if err := db.Where("id = ? AND user_id = ?", id, userID).First(&w).Error; err != nil {
		return nil, database.NotFound(err, ErrNotFound)
	}

	return &w, nil
}

func (r *repository) Create(ctx context.Context, w *Wallet) error {
	if err := database.Conn(ctx, r.db).Create(w).Error; err != nil {
		return uniqueViolation(err)
	}

	return nil
}

func (r *repository) Update(ctx context.Context, w *Wallet) error {
	// A map, so nil icon/color become NULL and false booleans are written.
	res := database.Conn(ctx, r.db).
		Model(w).
		Clauses(clause.Returning{}).
		Where("id = ? AND user_id = ?", w.ID, w.UserID).
		Updates(map[string]any{
			"name":            w.Name,
			"type":            w.Type,
			"initial_balance": w.InitialBalance,
			"icon":            w.Icon,
			"color":           w.Color,
			"is_default":      w.IsDefault,
			"is_archived":     w.IsArchived,
			"updated_at":      time.Now(),
		})
	if res.Error != nil {
		return uniqueViolation(res.Error)
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

func (r *repository) ClearDefault(ctx context.Context, userID uuid.UUID) error {
	return database.Conn(ctx, r.db).
		Model(&Wallet{}).
		Where("user_id = ? AND is_default", userID).
		Updates(map[string]any{
			"is_default": false,
			"updated_at": time.Now(),
		}).Error
}

func (r *repository) Delete(ctx context.Context, userID, id uuid.UUID) error {
	res := database.Conn(ctx, r.db).Delete(&Wallet{}, "id = ? AND user_id = ?", id, userID)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

// HasTransactions queries the transactions table directly to avoid importing
// the transaction package.
func (r *repository) HasTransactions(ctx context.Context, id uuid.UUID) (bool, error) {
	var ok bool
	err := database.Conn(ctx, r.db).
		Raw("SELECT EXISTS (SELECT 1 FROM transactions WHERE wallet_id = ? OR to_wallet_id = ?)", id, id).
		Scan(&ok).Error

	return ok, err
}

// detailQuery selects the user's wallets with their provider logo and balance.
func (r *repository) detailQuery(ctx context.Context, userID uuid.UUID) *gorm.DB {
	return database.Conn(ctx, r.db).
		Table("wallets w").
		Select("w.*, p.logo_key, w.initial_balance + COALESCE(b.delta, 0) AS current_balance").
		Joins("LEFT JOIN payment_providers p ON p.id = w.provider_id AND p.deleted_at IS NULL").
		Joins(balanceJoin, userID, userID).
		Where("w.user_id = ?", userID)
}

// uniqueViolation maps the wallets unique indexes to domain errors.
func uniqueViolation(err error) error {
	switch {
	case database.IsUniqueViolation(err, nameUniqueIndex):
		return ErrNameTaken
	case database.IsUniqueViolation(err, defaultUniqueIndex):
		return ErrDefaultRace
	}

	return err
}
