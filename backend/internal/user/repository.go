package user

import (
	"context"
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
	// UpdateProfile sets the non-nil fields; at least one must be set.
	UpdateProfile(ctx context.Context, id uuid.UUID, name, timezone *string) (*User, error)
	// Timezone returns the user's IANA timezone name, or ErrNotFound.
	Timezone(ctx context.Context, id uuid.UUID) (string, error)
	// UpdateAvatarKey sets the avatar object key; nil clears it.
	UpdateAvatarKey(ctx context.Context, id uuid.UUID, key *string) (*User, error)
	UpdateRole(ctx context.Context, id uuid.UUID, roleID int64) (*User, error)
	// UpdatePassword sets the password hash and increments the token version,
	// revoking every token issued before.
	UpdatePassword(ctx context.Context, id uuid.UUID, hash string) (*User, error)
	// TokenVersion returns the user's current token version, or ErrNotFound.
	// It satisfies httpx.TokenVersions for RequireAuth.
	TokenVersion(ctx context.Context, id uuid.UUID) (int, error)
	// BumpTokenVersion increments the token version, revoking every token
	// issued before.
	BumpTokenVersion(ctx context.Context, id uuid.UUID) error
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
		return nil, database.NotFound(err, ErrNotFound)
	}

	return &u, nil
}

func (r *repository) FindByEmail(ctx context.Context, email string) (*User, error) {
	var u User
	if err := database.Conn(ctx, r.db).
		Where("lower(email) = lower(?)", email).
		First(&u).Error; err != nil {
		return nil, database.NotFound(err, ErrNotFound)
	}

	return &u, nil
}

func (r *repository) UpdateProfile(ctx context.Context, id uuid.UUID, name, timezone *string) (*User, error) {
	cols := map[string]any{}
	if name != nil {
		cols["name"] = *name
	}
	if timezone != nil {
		cols["timezone"] = *timezone
	}

	return r.update(ctx, id, cols)
}

func (r *repository) Timezone(ctx context.Context, id uuid.UUID) (string, error) {
	var u User
	if err := database.Conn(ctx, r.db).Select("timezone").Take(&u, "id = ?", id).Error; err != nil {
		return "", database.NotFound(err, ErrNotFound)
	}

	return u.Timezone, nil
}

func (r *repository) UpdateAvatarKey(ctx context.Context, id uuid.UUID, key *string) (*User, error) {
	return r.update(ctx, id, map[string]any{"avatar_key": key})
}

func (r *repository) UpdateRole(ctx context.Context, id uuid.UUID, roleID int64) (*User, error) {
	return r.update(ctx, id, map[string]any{"role_id": roleID})
}

func (r *repository) UpdatePassword(ctx context.Context, id uuid.UUID, hash string) (*User, error) {
	return r.update(ctx, id, map[string]any{
		"password_hash": hash,
		"token_version": gorm.Expr("token_version + 1"),
	})
}

func (r *repository) TokenVersion(ctx context.Context, id uuid.UUID) (int, error) {
	var u User
	if err := database.Conn(ctx, r.db).Select("token_version").Take(&u, "id = ?", id).Error; err != nil {
		return 0, database.NotFound(err, ErrNotFound)
	}

	return u.TokenVersion, nil
}

func (r *repository) BumpTokenVersion(ctx context.Context, id uuid.UUID) error {
	_, err := r.update(ctx, id, map[string]any{"token_version": gorm.Expr("token_version + 1")})
	return err
}

func (r *repository) Delete(ctx context.Context, id uuid.UUID) error {
	res := database.Conn(ctx, r.db).Delete(&User{}, "id = ?", id)
	return database.Affected(res, ErrNotFound)
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
	if err := database.Affected(res, ErrNotFound); err != nil {
		return nil, err
	}

	return &u, nil
}
