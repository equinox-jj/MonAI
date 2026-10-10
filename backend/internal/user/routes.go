package user

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the user endpoints on the /api/v1 router.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	me := r.Group("/me", fiber.Handler(auth))
	me.Get("/", h.GetMe)
	me.Patch("/", h.UpdateMe)
	me.Delete("/", h.DeleteMe)
	me.Put("/avatar", h.SetAvatar)
	me.Delete("/avatar", h.DeleteAvatar)
}
