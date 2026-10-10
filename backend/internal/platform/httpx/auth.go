package httpx

import (
	"context"
	"errors"
	"strings"

	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/security"
)

// userIDKey is the Locals key RequireAuth stores the user ID under.
type userIDKey struct{}

// RequireAuth is the middleware for routes that need a Bearer token. Features
// receive it in RegisterRoutes and pass it as fiber.Handler(auth).
type RequireAuth fiber.Handler

// TokenVersions looks up a user's current token version. It returns an error
// matching ErrNotFound when the user no longer exists.
type TokenVersions interface {
	TokenVersion(ctx context.Context, userID uuid.UUID) (int, error)
}

// NewRequireAuth verifies "Authorization: Bearer <JWT>" and stores its subject
// for UserID. The token's version must equal the user's current one, so
// logout-all and password changes revoke older tokens, and a deleted user's
// tokens stop working. Every failure is 401 unauthorized; the token is never
// logged.
func NewRequireAuth(jwt security.JWTManager, versions TokenVersions) RequireAuth {
	return func(c fiber.Ctx) error {
		scheme, token, ok := strings.Cut(c.Get(fiber.HeaderAuthorization), " ")
		if !ok || !strings.EqualFold(scheme, "Bearer") || token == "" {
			return ErrUnauthorized
		}

		sub, err := jwt.Parse(token)
		if err != nil {
			return ErrUnauthorized
		}

		current, err := versions.TokenVersion(c.Context(), sub.UserID)
		if errors.Is(err, ErrNotFound) {
			return ErrUnauthorized
		}
		if err != nil {
			return err
		}
		if sub.Version != current {
			return ErrUnauthorized
		}

		fiber.Locals(c, userIDKey{}, sub.UserID)

		return c.Next()
	}
}

// UserID returns the authenticated user's ID. It is uuid.Nil on routes
// without RequireAuth.
func UserID(c fiber.Ctx) uuid.UUID {
	return fiber.Locals[uuid.UUID](c, userIDKey{})
}
