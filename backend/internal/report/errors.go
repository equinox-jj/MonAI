package report

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var ErrMonthInvalid = httpx.InvalidField("month", "invalid_format", "must be YYYY-MM")
