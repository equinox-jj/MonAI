package budget

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var (
	ErrNotFound = httpx.ErrNotFound

	ErrMonthInvalid = httpx.InvalidField("month", "invalid_format", "must be YYYY-MM")
	ErrLimitInvalid = httpx.InvalidField("limit_amount", "min", "must be at least 1")
)
