package httpx

import (
	"time"

	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/fiber/v3/middleware/limiter"
)

// KeyFunc returns the bucket key for a request. An empty key skips the limit.
type KeyFunc func(c fiber.Ctx) string

// RateLimit allows max requests per window for each key, counted in memory.
// Over the limit it returns ErrRateLimited; the limiter has already set
// Retry-After. Put it before the route's handler.
func RateLimit(max int, window time.Duration, key KeyFunc) fiber.Handler {
	return limiter.New(limiter.Config{
		Max:          max,
		Expiration:   window,
		KeyGenerator: func(c fiber.Ctx) string { return key(c) },
		Next:         func(c fiber.Ctx) bool { return key(c) == "" },
		LimitReached: func(fiber.Ctx) error { return ErrRateLimited },
	})
}

// ByIP keys requests by client IP.
func ByIP(c fiber.Ctx) string {
	return c.IP()
}

// ByUser keys requests by the authenticated user. Put it after RequireAuth.
func ByUser(c fiber.Ctx) string {
	return UserID(c).String()
}
