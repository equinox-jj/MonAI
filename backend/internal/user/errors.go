package user

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound   = httpx.ErrNotFound
	ErrEmailTaken = httpx.ErrConflict.WithFields(httpx.FieldError{
		Field:   "email",
		Code:    "already_exists",
		Message: "This email is already registered.",
	})
	ErrInvalidPassword = httpx.NewError(fiber.StatusUnprocessableEntity, "invalid_password",
		"The password is incorrect.")

	ErrNameBlank = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "required",
		Message: "must not be blank",
	})

	// Avatar confirm failures (PUT /me/avatar), reported on object_key.
	ErrAvatarKeyInvalid = avatarKeyError("invalid", "must be an object key returned by the upload URL endpoint")
	ErrAvatarNotFound   = avatarKeyError("not_found", "no uploaded object was found for this key")
	ErrAvatarType       = avatarKeyError("content_type", "must be image/jpeg, image/png or image/webp")
	ErrAvatarTooLarge   = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "object_key",
		Code:    "max_size",
		Message: "must be at most 2 MB",
		Params:  map[string]any{"max": AvatarMaxSizeBytes},
	})
)

func avatarKeyError(code, message string) *httpx.Error {
	return httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "object_key",
		Code:    code,
		Message: message,
	})
}
