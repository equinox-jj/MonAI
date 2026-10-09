package category

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound  = httpx.ErrNotFound
	ErrNameTaken = httpx.ErrConflict.WithMessage("Category name already exists").WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "already_exists",
		Message: "is already used by another category of this type",
	})

	ErrSystemLocked = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"system_category_locked",
		"This category cannot be changed this way",
	)
	ErrHideSystem   = ErrSystemLocked.WithMessage("System categories cannot be hidden")
	ErrDeleteLocked = ErrSystemLocked.WithMessage("Default and system categories cannot be deleted")

	ErrHasTransactions = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"category_has_transactions",
		"This category has transactions. Choose a category to move them to",
	)

	ErrNameBlank = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "required",
		Message: "must not be blank",
	})
	ErrNoFields      = httpx.ErrValidationFailed.WithMessage("At least one field is required")
	ErrMoveToInvalid = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "move_to",
		Code:    "invalid",
		Message: "must be another category of the same type",
	})
)
