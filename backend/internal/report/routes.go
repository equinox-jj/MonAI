package report

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the report endpoints on the /api/v1 router. Every
// route requires a Bearer token.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	g := r.Group("/reports", fiber.Handler(auth))
	g.Get("/monthly", h.Monthly)
}
