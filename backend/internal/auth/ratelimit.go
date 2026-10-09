package auth

import (
	"encoding/json"
	"time"

	"github.com/gofiber/fiber/v3"
)

// Auth rate limits. Every login attempt counts, successful or not: the
// limiter only sees *fiber.Error statuses, not our *httpx.Error ones.
const (
	registerMax    = 5
	registerWindow = time.Hour

	loginIPMax    = 20
	loginEmailMax = 10
	loginWindow   = 15 * time.Minute
)

// loginEmailKey keys login attempts by normalized email. It returns "" for a
// malformed body or a missing email, which skips the limit; the handler then
// rejects the request.
func loginEmailKey(c fiber.Ctx) string {
	var body struct {
		Email string `json:"email"`
	}
	if err := json.Unmarshal(c.Body(), &body); err != nil {
		return ""
	}

	email := normalizeEmail(body.Email)
	if email == "" {
		return ""
	}

	return "login:" + email
}
