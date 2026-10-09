package rbac

import (
	"errors"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrRoleNotFound = httpx.ErrNotFound
	ErrLastAdmin    = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"last_admin",
		"You are the last admin. Assign another admin first",
	)
)

// ErrUserNotFound means the token's user no longer exists. RequirePermission
// turns it into 401.
var ErrUserNotFound = errors.New("rbac: user not found")
