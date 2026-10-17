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
func RegisterRoutes(r fiber.Router, ctrl *Controller, auth httpx.RequireAuth, perm rbac.RequirePermission) {
	r.Get("/payment-providers", httpx.RateLimit(catalogMax, catalogWindow, httpx.ByIP), ctrl.Catalog)

	g := r.Group("/admin/payment-providers", fiber.Handler(auth))
	g.Get("", perm(rbac.PermProviderView), ctrl.List)
	g.Post("", perm(rbac.PermProviderCreate), ctrl.Create)
	g.Get("/:id", perm(rbac.PermProviderView), ctrl.Get)
	g.Patch("/:id", perm(rbac.PermProviderUpdate), ctrl.Update)
	g.Delete("/:id", perm(rbac.PermProviderDelete), ctrl.Delete)
	g.Patch("/:id/status", perm(rbac.PermProviderUpdate), ctrl.SetStatus)
	g.Put("/:id/logo", perm(rbac.PermProviderUpdate), ctrl.SetLogo)
}
