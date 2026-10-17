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
)
