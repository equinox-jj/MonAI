package health

import (
	"time"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// Health check limit per client IP. Each check pings Postgres and MinIO, so
// an unlimited public endpoint would multiply load on both.
const (
	checkMax    = 60
	checkWindow = time.Minute
)

// RegisterRoutes mounts the health check on the /api/v1 router. It is public.
func RegisterRoutes(r fiber.Router, h Handler) {
	r.Get("/health", httpx.RateLimit(checkMax, checkWindow, httpx.ByIP), h.Check)
}
