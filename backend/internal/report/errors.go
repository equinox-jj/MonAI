package report

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var ErrMonthInvalid = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
	Field:   "month",
	Code:    "invalid_format",
	Message: "must be YYYY-MM",
})
