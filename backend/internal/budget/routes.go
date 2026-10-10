package budget

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the budget endpoints on the /api/v1 router. Every
// route requires a Bearer token.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	g := r.Group("/budgets", fiber.Handler(auth))
	g.Get("/:month", h.Get)
	g.Put("/:month", h.Set)
	g.Delete("/:month", h.Delete)
}
