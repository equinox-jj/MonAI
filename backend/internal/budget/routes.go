package budget

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the budget endpoints on the /api/v1 router. Every
// route requires a Bearer token.
func RegisterRoutes(r fiber.Router, ctrl *Controller, auth httpx.RequireAuth) {
	g := r.Group("/budgets", fiber.Handler(auth))
	g.Get("/:month", ctrl.Get)
	g.Put("/:month", ctrl.Set)
	g.Delete("/:month", ctrl.Delete)
}
