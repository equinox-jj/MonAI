package auth

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the auth endpoints on the /api/v1 router. Fiber runs
// a route's handlers in order, so the limiters come first; the IP limit runs
// before the email one so a single IP cannot fill many email buckets.
func RegisterRoutes(r fiber.Router, h Handler) {
	g := r.Group("/auth")
	g.Post("/register",
		httpx.RateLimit(registerMax, registerWindow, httpx.ByIP),
		h.Register,
	)
	g.Post("/login",
		httpx.RateLimit(loginIPMax, loginWindow, httpx.ByIP),
		httpx.RateLimit(loginEmailMax, loginWindow, loginEmailKey),
		h.Login,
	)
}
