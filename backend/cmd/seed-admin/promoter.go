package main

import (
	"context"
	"errors"
	"log/slog"
	"strings"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
	"github.com/equinox-jj/MonAI/backend/internal/user"
)

// permissionCacheNote reminds the operator that a running API serves cached
// permissions for up to a minute.
const permissionCacheNote = "a running API applies the change within 1 minute"

// promoter assigns the admin role to an existing user.
type promoter struct {
	users user.Repository
	roles rbac.Repository
	tx    database.TxManager
	log   *slog.Logger
}

func newPromoter(users user.Repository, roles rbac.Repository, tx database.TxManager, log *slog.Logger) *promoter {
	return &promoter{users: users, roles: roles, tx: tx, log: log}
}

// promote gives the user with email the admin role. It is a no-op when the
// user is already an admin. Promoting never removes an admin, so the
// last_admin rule does not apply.
func (p *promoter) promote(ctx context.Context, email string) error {
	return p.tx.WithinTx(ctx, func(ctx context.Context) error {
		admin, err := p.roles.FindRoleBySlug(ctx, rbac.RoleAdmin)
		if errors.Is(err, rbac.ErrRoleNotFound) {
			return errors.New("admin role missing; run migrations first")
		}
		if err != nil {
			return err
		}

		u, err := p.users.FindByEmail(ctx, strings.TrimSpace(email))
		if errors.Is(err, user.ErrNotFound) {
			return errors.New("no user with that email; register first")
		}
		if err != nil {
			return err
		}

		if u.RoleID == admin.ID {
			p.log.Info("seed-admin: user is already an admin", "user_id", u.ID, "email", u.Email)
			return nil
		}

		if _, err := p.users.UpdateRole(ctx, u.ID, admin.ID); err != nil {
			return err
		}
		p.log.Info("seed-admin: promoted user to admin", "user_id", u.ID, "email", u.Email, "note", permissionCacheNote)
		return nil
	})
}
