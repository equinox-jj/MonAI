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
	return newLimiter(max, window, key, false)
}

// RateLimitFailures is RateLimit counting only failed requests (status 400 or
// above), so successful ones never use up the bucket. The limiter reads the
// response status, so put ErrorStatus between it and the handler.
func RateLimitFailures(max int, window time.Duration, key KeyFunc) fiber.Handler {
	return newLimiter(max, window, key, true)
}

// ErrorStatus sets the response status from the error the rest of the chain
// returns, before NewErrorHandler writes it, so the RateLimitFailures limiters
// before it can tell a failure from a success.
func ErrorStatus(c fiber.Ctx) error {
	err := c.Next()
	if err != nil {
		c.Status(toError(err).Status)
	}
	return err
}

func newLimiter(max int, window time.Duration, key KeyFunc, failuresOnly bool) fiber.Handler {
	return limiter.New(limiter.Config{
		Max:                    max,
		Expiration:             window,
		KeyGenerator:           func(c fiber.Ctx) string { return key(c) },
		Next:                   func(c fiber.Ctx) bool { return key(c) == "" },
		LimitReached:           func(fiber.Ctx) error { return ErrRateLimited },
		SkipSuccessfulRequests: failuresOnly,
	})
}

// ByIP keys requests by client IP: the connecting IP, or the X-Forwarded-For
// client when the request comes through a trusted proxy (TRUSTED_PROXIES).
func ByIP(c fiber.Ctx) string {
	return c.IP()
}

// ByUser keys requests by the authenticated user. Put it after RequireAuth.
func ByUser(c fiber.Ctx) string {
	return UserID(c).String()
}
