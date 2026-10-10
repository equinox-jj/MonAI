package budget

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var (
	ErrNotFound = httpx.ErrNotFound

	ErrMonthInvalid = fieldError("month", "invalid_format", "must be YYYY-MM")
	ErrLimitInvalid = fieldError("limit_amount", "min", "must be at least 1")
)

func fieldError(field, code, message string) *httpx.Error {
	return httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   field,
		Code:    code,
		Message: message,
	})
}
