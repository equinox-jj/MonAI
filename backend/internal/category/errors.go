package category

import (
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound  = httpx.ErrNotFound
	ErrNameTaken = httpx.ErrConflict.WithMessage("Category name already exists").WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "already_exists",
		Message: "is already used by another category of this type",
	})
)
