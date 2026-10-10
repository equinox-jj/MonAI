package auth

import (
	"encoding/json"
	"time"

	"github.com/gofiber/fiber/v3"
)

// Auth rate limits. The IP limit counts every login attempt. The email limits
// count failures only, so the account owner's own logins never lock them out.
// The email+IP bucket is the tight one; the email-only bucket is a looser cap
// on guessing one account from many IPs, so a single attacker IP can no longer
// lock a victim out.
const (
	registerMax    = 5
	registerWindow = time.Hour

	loginIPMax      = 20
	loginEmailIPMax = 10
	loginEmailMax   = 50
	loginWindow     = 15 * time.Minute

	// Wrong current passwords per user, so a stolen token cannot be used to
	// guess the password.
	passwordFailMax    = 5
	passwordFailWindow = 15 * time.Minute
)

// loginEmailKey keys failed logins by normalized email.
func loginEmailKey(c fiber.Ctx) string {
	email := loginEmail(c)
	if email == "" {
		return ""
	}

	return "login:" + email
}

// loginEmailIPKey keys failed logins by normalized email and client IP.
func loginEmailIPKey(c fiber.Ctx) string {
	email := loginEmail(c)
	if email == "" {
		return ""
	}

	return "login:" + email + "|" + c.IP()
}

// loginEmail returns the body's normalized email, or "" for a malformed body
// or a missing email, which skips the limit; the handler then rejects the
// request.
func loginEmail(c fiber.Ctx) string {
	var body struct {
		Email string `json:"email"`
	}
	if err := json.Unmarshal(c.Body(), &body); err != nil {
		return ""
	}

	return normalizeEmail(body.Email)
}
