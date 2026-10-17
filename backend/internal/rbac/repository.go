package rbac

import (
	"context"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

// holdsAllPermissions matches a role (aliased r) that is granted every row in
// permissions. An empty permissions table matches nothing, so no role is
// treated as a full admin by vacuous truth.
const holdsAllPermissions = `EXISTS (SELECT 1 FROM permissions)
	AND NOT EXISTS (
		SELECT 1 FROM permissions p
		WHERE NOT EXISTS (
			SELECT 1 FROM role_permissions rp
			WHERE rp.role_id = r.id AND rp.permission_id = p.id
		)
	)`

type Repository interface {
	FindRoleByID(ctx context.Context, id int64) (*Role, error)
	FindRoleBySlug(ctx context.Context, slug string) (*Role, error)
	// FindDefaultRole returns the role assigned on register.
	FindDefaultRole(ctx context.Context) (*Role, error)
	// ListPermissionCodes returns the role's permission codes sorted by code;
	// an unknown role or one without grants yields an empty slice.
	ListPermissionCodes(ctx context.Context, roleID int64) ([]string, error)
	// RoleHoldsAllPermissions reports whether the role is granted every permission.
	RoleHoldsAllPermissions(ctx context.Context, roleID int64) (bool, error)
	// CountFullAdminsExcept counts the users other than userID whose role holds
	// every permission. It locks the counted rows, so call it inside
	// TxManager.WithinTx to keep two concurrent removals from both passing the
	// last_admin check.
	CountFullAdminsExcept(ctx context.Context, userID uuid.UUID) (int64, error)
	// FindUserRoleID returns the user's role ID, or ErrUserNotFound. It reads
	// users directly because the user package already imports rbac.
	FindUserRoleID(ctx context.Context, userID uuid.UUID) (int64, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) FindRoleByID(ctx context.Context, id int64) (*Role, error) {
	return r.findRole(ctx, "id = ?", id)
}

func (r *repository) FindRoleBySlug(ctx context.Context, slug string) (*Role, error) {
	return r.findRole(ctx, "slug = ?", slug)
}

func (r *repository) FindDefaultRole(ctx context.Context) (*Role, error) {
	return r.findRole(ctx, "is_default")
}

func (r *repository) ListPermissionCodes(ctx context.Context, roleID int64) ([]string, error) {
	codes := []string{}
	err := database.Conn(ctx, r.db).
		Model(&Permission{}).
		Joins("JOIN role_permissions rp ON rp.permission_id = permissions.id").
		Where("rp.role_id = ?", roleID).
		Order("permissions.code").
		Pluck("permissions.code", &codes).Error
	if err != nil {
		return nil, err
	}

	return codes, nil
}

func (r *repository) RoleHoldsAllPermissions(ctx context.Context, roleID int64) (bool, error) {
	var ok bool
	err := database.Conn(ctx, r.db).
		Raw(`SELECT EXISTS (SELECT 1 FROM roles r WHERE r.id = ? AND `+holdsAllPermissions+`)`, roleID).
		Scan(&ok).Error

	return ok, err
}

func (r *repository) CountFullAdminsExcept(ctx context.Context, userID uuid.UUID) (int64, error) {
	var n int64
	err := database.Conn(ctx, r.db).
		Raw(`SELECT count(*) FROM (
			SELECT u.id FROM users u
			JOIN roles r ON r.id = u.role_id
			WHERE u.id <> ? AND `+holdsAllPermissions+`
			FOR UPDATE OF u
		) admins`, userID).
		Scan(&n).Error

	return n, err
}

func (r *repository) FindUserRoleID(ctx context.Context, userID uuid.UUID) (int64, error) {
	var u struct{ RoleID int64 }
	if err := database.Conn(ctx, r.db).
		Table("users").
		Select("role_id").
		Take(&u, "id = ?", userID).Error; err != nil {
		return 0, database.NotFound(err, ErrUserNotFound)
	}

	return u.RoleID, nil
}

func (r *repository) findRole(ctx context.Context, query string, args ...any) (*Role, error) {
	var role Role
	if err := database.Conn(ctx, r.db).Where(query, args...).First(&role).Error; err != nil {
		return nil, database.NotFound(err, ErrRoleNotFound)
	}

	return &role, nil
}
