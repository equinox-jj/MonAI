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
func RegisterRoutes(r fiber.Router, ctrl *Controller, auth httpx.RequireAuth) {
	g := r.Group("/transactions", fiber.Handler(auth))
	g.Get("", ctrl.List)
	g.Post("", ctrl.Create)
	g.Post("/receipt", // before the /:id routes
		httpx.RateLimit(receiptUploadMax, receiptUploadWindow, httpx.ByUser),
		ctrl.UploadReceipt,
	)
	g.Get("/:id", ctrl.Get)
	g.Patch("/:id", ctrl.Update)
	g.Delete("/:id", ctrl.Delete)
	g.Post("/:id/restore", ctrl.Restore)
}
