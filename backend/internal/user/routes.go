package user

import (
	"time"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// Per-user limits: avatar uploads, and wrong passwords on account deletion so
// a stolen token cannot be used to guess the password.
const (
	avatarUploadMax    = 10
	avatarUploadWindow = time.Hour

	deleteFailMax    = 5
	deleteFailWindow = 15 * time.Minute
)

// RegisterRoutes mounts the user endpoints on the /api/v1 router.
func RegisterRoutes(r fiber.Router, h Handler, auth httpx.RequireAuth) {
	me := r.Group("/me", fiber.Handler(auth))
	me.Get("/", h.GetMe)
	me.Patch("/", h.UpdateMe)
	me.Delete("/",
		httpx.RateLimitFailures(deleteFailMax, deleteFailWindow, httpx.ByUser),
		httpx.ErrorStatus,
		h.DeleteMe,
	)
	me.Put("/avatar", httpx.RateLimit(avatarUploadMax, avatarUploadWindow, httpx.ByUser), h.SetAvatar)
	me.Delete("/avatar", h.DeleteAvatar)
}
