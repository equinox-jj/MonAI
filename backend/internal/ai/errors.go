package ai

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	// ErrUnavailable means the AI provider failed, timed out or ran out of
	// quota. The client falls back to its local parser.
	ErrUnavailable = httpx.NewError(
		fiber.StatusServiceUnavailable,
		"ai_unavailable",
		"AI parsing is temporarily unavailable",
	)

	ErrTodayOutOfRange = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "today",
		Code:    "out_of_range",
		Message: "must be within one day of the current date in timezone",
	})
)
