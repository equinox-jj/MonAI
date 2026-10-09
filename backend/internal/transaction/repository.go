package transaction

import (
	"context"
	"errors"
	"strings"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

// likeEscaper escapes LIKE wildcards with PostgreSQL's default escape
// character, so a search term matches literally.
var likeEscaper = strings.NewReplacer(`\`, `\\`, `%`, `\%`, `_`, `\_`)

// Cursor is the keyset position after which the next page starts: the last
// row of the previous page. Encoding it as an opaque string is the service's
// job.
type Cursor struct {
	Date time.Time
	ID   uuid.UUID
}

// ListFilter narrows List. From and To are a half-open date range [From, To).
// Nil fields and an empty Query are not filtered.
type ListFilter struct {
	From       time.Time
	To         time.Time
	WalletID   *uuid.UUID // source or destination wallet
	CategoryID *uuid.UUID
	Type       *Type
	Query      string // case-insensitive search in note and merchant
	After      *Cursor
	Limit      int // pass the page size + 1 to detect has_more
}

type Repository interface {
	// List returns the user's non-deleted transactions ordered by date DESC,
	// then id DESC, at most filter.Limit rows. It never returns nil.
	List(ctx context.Context, userID uuid.UUID, filter ListFilter) ([]Transaction, error)
	// FindByID returns ErrNotFound when the row is missing, soft-deleted or
	// belongs to another user.
	FindByID(ctx context.Context, userID, id uuid.UUID) (*Transaction, error)
	// FindDeletedByID returns a soft-deleted transaction, or ErrNotFound when
	// the row is missing, not deleted or belongs to another user.
	FindDeletedByID(ctx context.Context, userID, id uuid.UUID) (*Transaction, error)
	// Create inserts t and fills its ID and timestamps.
	Create(ctx context.Context, t *Transaction) error
	// Update writes t's editable fields, scoped to t.UserID and non-deleted
	// rows, and refreshes t from the updated row. source is never changed.
	Update(ctx context.Context, t *Transaction) error
	// Delete soft-deletes the transaction.
	Delete(ctx context.Context, userID, id uuid.UUID) error
	// Restore undoes a soft delete and returns the restored row, or
	// ErrNotFound when the row is missing, not deleted or belongs to another
	// user.
	Restore(ctx context.Context, userID, id uuid.UUID) (*Transaction, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) List(ctx context.Context, userID uuid.UUID, filter ListFilter) ([]Transaction, error) {
	q := database.Conn(ctx, r.db).
		Where("user_id = ? AND date >= ? AND date < ?", userID, filter.From, filter.To)
	if filter.WalletID != nil {
		q = q.Where("(wallet_id = ? OR to_wallet_id = ?)", *filter.WalletID, *filter.WalletID)
	}
	if filter.CategoryID != nil {
		q = q.Where("category_id = ?", *filter.CategoryID)
	}
	if filter.Type != nil {
		q = q.Where("type = ?", *filter.Type)
	}
	if filter.Query != "" {
		pattern := "%" + likeEscaper.Replace(filter.Query) + "%"
		q = q.Where("(note ILIKE ? OR merchant ILIKE ?)", pattern, pattern)
	}
	if filter.After != nil {
		// Row comparison matches the (user_id, date DESC, id DESC) index.
		q = q.Where("(date, id) < (?, ?)", filter.After.Date, filter.After.ID)
	}

	ts := []Transaction{}
	if err := q.Order("date DESC, id DESC").Limit(filter.Limit).Find(&ts).Error; err != nil {
		return nil, err
	}

	return ts, nil
}

func (r *repository) FindByID(ctx context.Context, userID, id uuid.UUID) (*Transaction, error) {
	var t Transaction
	if err := database.Conn(ctx, r.db).
		Where("id = ? AND user_id = ?", id, userID).
		First(&t).Error; err != nil {
		return nil, notFound(err)
	}

	return &t, nil
}

func (r *repository) FindDeletedByID(ctx context.Context, userID, id uuid.UUID) (*Transaction, error) {
	var t Transaction
	if err := database.Conn(ctx, r.db).
		Unscoped().
		Where("id = ? AND user_id = ? AND deleted_at IS NOT NULL", id, userID).
		First(&t).Error; err != nil {
		return nil, notFound(err)
	}

	return &t, nil
}

func (r *repository) Create(ctx context.Context, t *Transaction) error {
	return database.Conn(ctx, r.db).Create(t).Error
}

func (r *repository) Update(ctx context.Context, t *Transaction) error {
	// A map, so nil pointers become NULL. A type change needs this to clear
	// to_wallet_id or category_id (transactions_shape_check).
	res := database.Conn(ctx, r.db).
		Model(t).
		Clauses(clause.Returning{}).
		Where("id = ? AND user_id = ?", t.ID, t.UserID).
		Updates(map[string]any{
			"type":         t.Type,
			"amount":       t.Amount,
			"wallet_id":    t.WalletID,
			"to_wallet_id": t.ToWalletID,
			"category_id":  t.CategoryID,
			"date":         t.Date,
			"note":         t.Note,
			"merchant":     t.Merchant,
			"receipt_key":  t.ReceiptKey,
			"updated_at":   time.Now(),
		})
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

func (r *repository) Delete(ctx context.Context, userID, id uuid.UUID) error {
	res := database.Conn(ctx, r.db).Delete(&Transaction{}, "id = ? AND user_id = ?", id, userID)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

func (r *repository) Restore(ctx context.Context, userID, id uuid.UUID) (*Transaction, error) {
	var t Transaction
	res := database.Conn(ctx, r.db).
		Unscoped().
		Model(&t).
		Clauses(clause.Returning{}).
		Where("id = ? AND user_id = ? AND deleted_at IS NOT NULL", id, userID).
		Updates(map[string]any{
			"deleted_at": nil,
			"updated_at": time.Now(),
		})
	if res.Error != nil {
		return nil, res.Error
	}
	if res.RowsAffected == 0 {
		return nil, ErrNotFound
	}

	return &t, nil
}

func notFound(err error) error {
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	}

	return err
}
