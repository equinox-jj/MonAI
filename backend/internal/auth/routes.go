package auth

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the auth endpoints on the /api/v1 router. Fiber runs
// a route's handlers in order, so the limiters come first; the IP limit runs
// before the email ones so a single IP cannot fill many email buckets, and
// httpx.ErrorStatus sits right before the handler so the failure-only limiters
// see its status.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	g := r.Group("/auth")
	g.Post("/register",
		httpx.RateLimit(registerMax, registerWindow, httpx.ByIP),
		h.Register,
	)
	g.Post("/login",
		httpx.RateLimit(loginIPMax, loginWindow, httpx.ByIP),
		httpx.RateLimitFailures(loginEmailIPMax, loginWindow, loginEmailIPKey),
		httpx.RateLimitFailures(loginEmailMax, loginWindow, loginEmailKey),
		httpx.ErrorStatus,
		h.Login,
	)
	g.Post("/logout-all", fiber.Handler(auth), h.LogoutAll)
	g.Put("/password",
		fiber.Handler(auth),
		httpx.RateLimitFailures(passwordFailMax, passwordFailWindow, httpx.ByUser),
		httpx.ErrorStatus,
		h.ChangePassword,
	)
}
