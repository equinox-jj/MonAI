package category

import (
	"context"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

const nameUniqueIndex = "categories_user_type_name"

// ListFilter narrows List. A nil Type returns both types.
type ListFilter struct {
	Type          *Type
	IncludeHidden bool
}

type Repository interface {
	// List returns the user's categories ordered by type, then system
	// categories last, then name (case-insensitive). It never returns nil.
	List(ctx context.Context, userID uuid.UUID, filter ListFilter) ([]Category, error)
	// FindByID returns ErrNotFound when the row is missing or belongs to
	// another user.
	FindByID(ctx context.Context, userID, id uuid.UUID) (*Category, error)
	// CreateMany inserts cs in one statement and fills their IDs and
	// timestamps. Used by POST /categories and register seeding.
	CreateMany(ctx context.Context, cs []Category) error
	// Update writes c's name, icon, color and is_hidden, scoped to c.UserID,
	// and refreshes c from the updated row.
	Update(ctx context.Context, c *Category) error
	Delete(ctx context.Context, userID, id uuid.UUID) error
	// HasTransactions reports whether any transaction, soft-deleted ones
	// included, references the category (the FK still points at them).
	HasTransactions(ctx context.Context, id uuid.UUID) (bool, error)
	// MoveTransactions repoints every transaction of fromID, soft-deleted ones
	// included, to toID. Run it with Delete inside TxManager.WithinTx.
	MoveTransactions(ctx context.Context, fromID, toID uuid.UUID) error
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) List(ctx context.Context, userID uuid.UUID, filter ListFilter) ([]Category, error) {
	q := database.Conn(ctx, r.db).Where("user_id = ?", userID)
	if filter.Type != nil {
		q = q.Where("type = ?", *filter.Type)
	}
	if !filter.IncludeHidden {
		q = q.Where("NOT is_hidden")
	}

	cs := []Category{}
	if err := q.Order("type, is_system, lower(name)").Find(&cs).Error; err != nil {
		return nil, err
	}

	return cs, nil
}

func (r *repository) FindByID(ctx context.Context, userID, id uuid.UUID) (*Category, error) {
	var c Category
	if err := database.Conn(ctx, r.db).
		Where("id = ? AND user_id = ?", id, userID).
		First(&c).Error; err != nil {
		return nil, database.NotFound(err, ErrNotFound)
	}

	return &c, nil
}

func (r *repository) CreateMany(ctx context.Context, cs []Category) error {
	if len(cs) == 0 {
		return nil
	}

	if err := database.Conn(ctx, r.db).Create(&cs).Error; err != nil {
		return nameTaken(err)
	}

	return nil
}

func (r *repository) Update(ctx context.Context, c *Category) error {
	// A map, so nil icon/color become NULL and false is_hidden is written.
	res := database.Conn(ctx, r.db).
		Model(c).
		Clauses(clause.Returning{}).
		Where("id = ? AND user_id = ?", c.ID, c.UserID).
		Updates(map[string]any{
			"name":       c.Name,
			"icon":       c.Icon,
			"color":      c.Color,
			"is_hidden":  c.IsHidden,
			"updated_at": time.Now(),
		})
	return nameTaken(database.Affected(res, ErrNotFound))
}

func (r *repository) Delete(ctx context.Context, userID, id uuid.UUID) error {
	res := database.Conn(ctx, r.db).Delete(&Category{}, "id = ? AND user_id = ?", id, userID)
	return database.Affected(res, ErrNotFound)
}

// HasTransactions and MoveTransactions query the transactions table directly
// to avoid importing the transaction package.
func (r *repository) HasTransactions(ctx context.Context, id uuid.UUID) (bool, error) {
	var ok bool
	err := database.Conn(ctx, r.db).
		Raw("SELECT EXISTS (SELECT 1 FROM transactions WHERE category_id = ?)", id).
		Scan(&ok).Error

	return ok, err
}

func (r *repository) MoveTransactions(ctx context.Context, fromID, toID uuid.UUID) error {
	err := database.Conn(ctx, r.db).
		Table("transactions").
		Where("category_id = ?", fromID).
		Updates(map[string]any{
			"category_id": toID,
			"updated_at":  time.Now(),
		}).Error
	// The target was deleted after the service checked it.
	if database.IsForeignKeyViolation(err, "transactions_category_owner_fkey") {
		return ErrMoveToInvalid
	}

	return err
}

func nameTaken(err error) error {
	if database.IsUniqueViolation(err, nameUniqueIndex) {
		return ErrNameTaken
	}

	return err
}
