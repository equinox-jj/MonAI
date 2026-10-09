package category

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the category endpoints on the /api/v1 router. Every
// route requires a Bearer token.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	g := r.Group("/categories", fiber.Handler(auth))
	g.Get("", h.List)
	g.Post("", h.Create)
	g.Patch("/:id", h.Update)
	g.Delete("/:id", h.Delete)
}
