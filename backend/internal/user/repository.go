package user

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

const emailUniqueIndex = "users_email_key"

type Repository interface {
	// Create inserts u and fills its ID and timestamps.
	Create(ctx context.Context, u *User) error
	FindByID(ctx context.Context, id uuid.UUID) (*User, error)
	// FindByEmail matches case-insensitively, like the users_email_key index.
	FindByEmail(ctx context.Context, email string) (*User, error)
	UpdateName(ctx context.Context, id uuid.UUID, name string) (*User, error)
	// UpdateAvatarKey sets the avatar object key; nil clears it.
	UpdateAvatarKey(ctx context.Context, id uuid.UUID, key *string) (*User, error)
	// Delete removes the user; their wallets, categories, transactions and
	// budgets cascade in the DB.
	Delete(ctx context.Context, id uuid.UUID) error
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) Create(ctx context.Context, u *User) error {
	if err := database.Conn(ctx, r.db).Create(u).Error; err != nil {
		if database.IsUniqueViolation(err, emailUniqueIndex) {
			return ErrEmailTaken
		}

		return err
	}

	return nil
}

func (r *repository) FindByID(ctx context.Context, id uuid.UUID) (*User, error) {
	var u User
	if err := database.Conn(ctx, r.db).First(&u, "id = ?", id).Error; err != nil {
		return nil, notFound(err)
	}

	return &u, nil
}

func (r *repository) FindByEmail(ctx context.Context, email string) (*User, error) {
	var u User
	if err := database.Conn(ctx, r.db).
		Where("lower(email) = lower(?)", email).
		First(&u).Error; err != nil {
		return nil, notFound(err)
	}

	return &u, nil
}

func (r *repository) UpdateName(ctx context.Context, id uuid.UUID, name string) (*User, error) {
	return r.update(ctx, id, map[string]any{"name": name})
}

func (r *repository) UpdateAvatarKey(ctx context.Context, id uuid.UUID, key *string) (*User, error) {
	return r.update(ctx, id, map[string]any{"avatar_key": key})
}

func (r *repository) Delete(ctx context.Context, id uuid.UUID) error {
	res := database.Conn(ctx, r.db).Delete(&User{}, "id = ?", id)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

// update writes cols (a map, so nil values become NULL) plus updated_at and
// returns the updated row.
func (r *repository) update(ctx context.Context, id uuid.UUID, cols map[string]any) (*User, error) {
	cols["updated_at"] = time.Now()

	var u User
	res := database.Conn(ctx, r.db).
		Model(&u).
		Clauses(clause.Returning{}).
		Where("id = ?", id).
		Updates(cols)
	if res.Error != nil {
		return nil, res.Error
	}
	if res.RowsAffected == 0 {
		return nil, ErrNotFound
	}

	return &u, nil
}

func notFound(err error) error {
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	}

	return err
}
