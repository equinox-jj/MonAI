package httpx

import (
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

// NewRequireAuth verifies "Authorization: Bearer <JWT>" and stores its subject
// for UserID. Every failure is 401 unauthorized; the token is never logged.
func NewRequireAuth(jwt security.JWTManager) RequireAuth {
	return func(c fiber.Ctx) error {
		scheme, token, ok := strings.Cut(c.Get(fiber.HeaderAuthorization), " ")
		if !ok || !strings.EqualFold(scheme, "Bearer") || token == "" {
			return ErrUnauthorized
		}

		userID, err := jwt.Parse(token)
		if err != nil {
			return ErrUnauthorized
		}

		fiber.Locals(c, userIDKey{}, userID)

		return c.Next()
	}
}

// UserID returns the authenticated user's ID. It is uuid.Nil on routes
// without RequireAuth.
func UserID(c fiber.Ctx) uuid.UUID {
	return fiber.Locals[uuid.UUID](c, userIDKey{})
}
