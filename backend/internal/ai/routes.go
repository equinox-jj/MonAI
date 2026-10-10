package ai

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// RegisterRoutes mounts the ai endpoints on the /api/v1 router. Every route
// requires a Bearer token; the per-user limit runs before the global one so
// one user over their limit does not use up the shared bucket.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	g := r.Group("/ai",
		fiber.Handler(auth),
		httpx.RateLimit(userMax, window, httpx.ByUser),
		httpx.RateLimit(globalMax, window, globalKey),
	)
	g.Post("/parse-transaction", h.ParseTransaction)
	g.Post("/parse-receipt", h.ParseReceipt)
}
