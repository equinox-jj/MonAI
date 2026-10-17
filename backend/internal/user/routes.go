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
	deleteFailMax      = 5
	deleteFailWindow   = 15 * time.Minute
)

// RegisterRoutes mounts the user endpoints on the /api/v1 router.
func RegisterRoutes(r fiber.Router, ctrl *Controller, auth httpx.RequireAuth) {
	me := r.Group("/me", fiber.Handler(auth))
	me.Get("/", ctrl.GetMe)
	me.Patch("/", ctrl.UpdateMe)
	me.Delete(
		"/",
		httpx.RateLimitFailures(deleteFailMax, deleteFailWindow, httpx.ByUser),
		httpx.ErrorStatus,
		ctrl.DeleteMe,
	)
	me.Put("/avatar", httpx.RateLimit(avatarUploadMax, avatarUploadWindow, httpx.ByUser), ctrl.SetAvatar)
	me.Delete("/avatar", ctrl.DeleteAvatar)
}
