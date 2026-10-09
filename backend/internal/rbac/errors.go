package rbac

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrRoleNotFound = httpx.ErrNotFound
	ErrLastAdmin    = httpx.NewError(fiber.StatusUnprocessableEntity, "last_admin",
		"You are the last admin. Assign another admin first.")
)
