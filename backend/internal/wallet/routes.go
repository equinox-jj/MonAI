package wallet

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the wallet endpoints on the /api/v1 router. Every
// route requires a Bearer token.
func RegisterRoutes(r fiber.Router, ctrl *Controller, auth httpx.RequireAuth) {
	g := r.Group("/wallets", fiber.Handler(auth))
	g.Get("", ctrl.List)
	g.Post("", ctrl.Create)
	g.Get("/:id", ctrl.Get)
	g.Patch("/:id", ctrl.Update)
	g.Delete("/:id", ctrl.Delete)
}
