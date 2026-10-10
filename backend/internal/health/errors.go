package health

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var ErrUnavailable = httpx.NewError(
	fiber.StatusServiceUnavailable,
	"service_unavailable",
	"A dependency is unavailable",
)
