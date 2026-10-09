package user

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var (
	ErrNotFound   = httpx.ErrNotFound
	ErrEmailTaken = httpx.ErrConflict.WithFields(httpx.FieldError{
		Field:   "email",
		Code:    "already_exists",
		Message: "This email is already registered.",
	})
)
