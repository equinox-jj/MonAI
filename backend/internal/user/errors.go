package user

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound        = httpx.ErrNotFound
	ErrEmailTaken      = httpx.ErrConflict.WithMessage("Email already exists")
	ErrInvalidPassword = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"invalid_password",
		"The password is incorrect",
	)

	ErrNameBlank = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "required",
		Message: "must not be blank",
	})
	ErrNoFields = httpx.ErrValidationFailed.WithMessage("At least one field is required")
)
