package category

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound     = httpx.ErrNotFound
	ErrNameTaken    = httpx.ErrConflict.WithMessage("Category name already exists")
	ErrSystemLocked = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"system_category_locked",
		"This category cannot be changed this way",
	)
	ErrHideSystem      = ErrSystemLocked.WithMessage("System categories cannot be hidden")
	ErrDeleteLocked    = ErrSystemLocked.WithMessage("Default and system categories cannot be deleted")
	ErrHasTransactions = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"category_has_transactions",
		"This category has transactions. Choose a category to move them to",
	)
	ErrMoveToInvalid = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "move_to",
		Code:    "invalid",
		Message: "must be another category of the same type",
	})
)
