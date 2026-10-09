package provider

import (
	"time"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
)

// Public catalog rate limit, per client IP.
const (
	catalogMax    = 60
	catalogWindow = time.Minute
)

// RegisterRoutes mounts the provider endpoints on the /api/v1 router. The
// catalog is public; admin routes need a Bearer token and a permission, and
// Fiber runs a route's handlers in order, so auth comes first.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth, perm rbac.RequirePermission) {
	r.Get("/payment-providers", httpx.RateLimit(catalogMax, catalogWindow, httpx.ByIP), h.Catalog)

	g := r.Group("/admin/payment-providers", fiber.Handler(auth))
	g.Get("", perm(rbac.PermProviderView), h.List)
	g.Post("", perm(rbac.PermProviderCreate), h.Create)
	g.Get("/:id", perm(rbac.PermProviderView), h.Get)
	g.Patch("/:id", perm(rbac.PermProviderUpdate), h.Update)
	g.Delete("/:id", perm(rbac.PermProviderDelete), h.Delete)
	g.Patch("/:id/status", perm(rbac.PermProviderUpdate), h.SetStatus)
	g.Post("/:id/logo-upload-url", perm(rbac.PermProviderUpdate), h.CreateLogoUploadURL)
	g.Put("/:id/logo", perm(rbac.PermProviderUpdate), h.ConfirmLogo)
}
