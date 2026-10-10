package transaction

import (
	"time"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// Receipt upload limit per user. Unattached receipts stay in storage, so this
// caps how fast one account can fill it.
const (
	receiptUploadMax    = 30
	receiptUploadWindow = time.Hour
)

// RegisterRoutes mounts the transaction endpoints on the /api/v1 router.
// Every route requires a Bearer token.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	g := r.Group("/transactions", fiber.Handler(auth))
	g.Get("", h.List)
	g.Post("", h.Create)
	g.Post("/receipt", // before the /:id routes
		httpx.RateLimit(receiptUploadMax, receiptUploadWindow, httpx.ByUser),
		h.UploadReceipt,
	)
	g.Get("/:id", h.Get)
	g.Patch("/:id", h.Update)
	g.Delete("/:id", h.Delete)
	g.Post("/:id/restore", h.Restore)
}
