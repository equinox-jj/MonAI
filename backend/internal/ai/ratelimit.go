package ai

import (
	"time"

	"github.com/gofiber/fiber/v3"
)

// AI rate limits. The global limit keeps all users together under the
// provider's free-tier quota; the per-user ones stop a single user from using
// it all up. The daily cap means emptying the shared bucket all day takes many
// accounts, not two. Tune userDailyMax to the provider's requests-per-day quota.
const (
	userMax      = 10
	globalMax    = 15
	window       = time.Minute
	userDailyMax = 200
	dailyWindow  = 24 * time.Hour
)

// globalKey puts every request in one bucket.
func globalKey(fiber.Ctx) string {
	return "ai"
}
