package ai

import (
	"time"

	"github.com/gofiber/fiber/v3"
)

// AI rate limits. The global limit keeps all users together under the
// provider's free-tier quota; the per-user one stops a single user from
// using it all up.
const (
	userMax   = 10
	globalMax = 15
	window    = time.Minute
)

// globalKey puts every request in one bucket.
func globalKey(fiber.Ctx) string {
	return "ai"
}
