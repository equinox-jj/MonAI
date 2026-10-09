package auth

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// ErrInvalidCredentials is returned for both an unknown email and a wrong
// password, so login does not reveal which accounts exist.
var ErrInvalidCredentials = httpx.NewError(fiber.StatusUnauthorized, "invalid_credentials",
	"Invalid email or password.")
