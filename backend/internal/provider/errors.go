package provider

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound   = httpx.ErrNotFound
	ErrSlugTaken  = httpx.ErrConflict.WithMessage("Provider slug already exists")
	ErrAliasTaken = httpx.ErrConflict.WithMessage("Provider alias already exists")

	ErrSystemLocked = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"system_provider_locked",
		"This provider cannot be changed this way",
	)
	ErrDeleteSystem     = ErrSystemLocked.WithMessage("System providers cannot be deleted")
	ErrDeactivateSystem = ErrSystemLocked.WithMessage("System providers cannot be deactivated")
	ErrSlugSystem       = ErrSystemLocked.WithMessage("The slug of a system provider cannot be changed")

	ErrNoFields  = httpx.ErrValidationFailed.WithMessage("At least one field is required")
	ErrNameBlank = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "required",
		Message: "must not be blank",
	})
	ErrSlugInvalid = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "slug",
		Code:    "invalid",
		Message: "must be lowercase letters and digits separated by single hyphens",
	})
	ErrAliasBlank = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "aliases",
		Code:    "invalid",
		Message: "must not contain blank aliases",
	})
	ErrContentType = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "content_type",
		Code:    "invalid",
		Message: "must be image/png, image/webp or image/svg+xml",
	})
	ErrFileTooLarge = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "size_bytes",
		Code:    "max",
		Message: "must be at most 524288",
		Params:  map[string]any{"max": logoMaxBytes},
	})
	ErrObjectKeyInvalid = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "object_key",
		Code:    "invalid",
		Message: "must be an uploaded logo of this provider within the size and type limits",
	})
)
