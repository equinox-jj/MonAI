package rbac

import (
	"context"
	"slices"
	"time"

	"github.com/google/uuid"
)

// permissionCacheTTL bounds how long a role change takes to reach
// RequirePermission and GET /me.
const permissionCacheTTL = time.Minute

type Service interface {
	// DefaultRole returns the role assigned on register.
	DefaultRole(ctx context.Context) (*Role, error)
	GetRole(ctx context.Context, id int64) (*Role, error)
	// PermissionCodes returns the role's permission codes sorted by code, from
	// the per-role cache. It never returns nil.
	PermissionCodes(ctx context.Context, roleID int64) ([]string, error)
	// HasPermission reports whether the role is granted code, from the
	// per-role cache.
	HasPermission(ctx context.Context, roleID int64, code string) (bool, error)
	// UserHasPermission reports whether the user's role is granted code. It
	// returns ErrUserNotFound when the user no longer exists.
	UserHasPermission(ctx context.Context, userID uuid.UUID, code string) (bool, error)
	// EnsureNotLastAdmin returns ErrLastAdmin when userID, holding roleID, is
	// the only user whose role holds every permission. Call it inside
	// TxManager.WithinTx together with the write that removes the role (e.g.
	// deleting the user), so the rows it locks stay locked until commit.
	EnsureNotLastAdmin(ctx context.Context, userID uuid.UUID, roleID int64) error
}

type service struct {
	repo  Repository
	cache *permissionCache
}

func NewService(repo Repository) Service {
	return newService(repo, newPermissionCache(permissionCacheTTL, time.Now, repo.ListPermissionCodes))
}

// newService lets tests inject a cache with a fake clock or loader.
func newService(repo Repository, cache *permissionCache) Service {
	return &service{repo: repo, cache: cache}
}

func (s *service) DefaultRole(ctx context.Context) (*Role, error) {
	return s.repo.FindDefaultRole(ctx)
}

func (s *service) GetRole(ctx context.Context, id int64) (*Role, error) {
	return s.repo.FindRoleByID(ctx, id)
}

func (s *service) PermissionCodes(ctx context.Context, roleID int64) ([]string, error) {
	e, err := s.cache.get(ctx, roleID)
	if err != nil {
		return nil, err
	}

	// Clone so callers cannot modify the cached slice. The repository returns
	// a non-nil slice, and Clone keeps it non-nil.
	return slices.Clone(e.codes), nil
}

func (s *service) HasPermission(ctx context.Context, roleID int64, code string) (bool, error) {
	e, err := s.cache.get(ctx, roleID)
	if err != nil {
		return false, err
	}
	_, ok := e.set[code]

	return ok, nil
}

func (s *service) UserHasPermission(ctx context.Context, userID uuid.UUID, code string) (bool, error) {
	roleID, err := s.repo.FindUserRoleID(ctx, userID)
	if err != nil {
		return false, err
	}

	return s.HasPermission(ctx, roleID, code)
}

func (s *service) EnsureNotLastAdmin(ctx context.Context, userID uuid.UUID, roleID int64) error {
	isAdmin, err := s.repo.RoleHoldsAllPermissions(ctx, roleID)
	if err != nil || !isAdmin {
		return err
	}

	others, err := s.repo.CountFullAdminsExcept(ctx, userID)
	if err != nil {
		return err
	}
	if others == 0 {
		return ErrLastAdmin
	}

	return nil
}
