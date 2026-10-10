package health

import "github.com/gofiber/fiber/v3"

// RegisterRoutes mounts the health check on the /api/v1 router. It is public.
func RegisterRoutes(r fiber.Router, h Handler) {
	r.Get("/health", h.Check)
}
