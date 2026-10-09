package rbac

import (
	"errors"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RequirePermission returns middleware that lets the request through only if
// the authenticated user's role is granted code. Features receive it in
// RegisterRoutes; put it after httpx.RequireAuth.
type RequirePermission func(code string) fiber.Handler

// NewRequirePermission checks permissions through the per-role cache, so a
// role change takes up to permissionCacheTTL to apply.
func NewRequirePermission(svc Service) RequirePermission {
	return func(code string) fiber.Handler {
		return func(c fiber.Ctx) error {
			ok, err := svc.UserHasPermission(c.Context(), httpx.UserID(c), code)
			if errors.Is(err, ErrUserNotFound) {
				return httpx.ErrUnauthorized
			}
			if err != nil {
				return err
			}
			if !ok {
				return httpx.ErrForbidden
			}

			return c.Next()
		}
	}
}
