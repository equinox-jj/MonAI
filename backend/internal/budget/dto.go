package budget

// ---------------------------------------------------------------- Requests

// SetBudgetRequest is the body of PUT /budgets/{month}.
type SetBudgetRequest struct {
	LimitAmount int64 `json:"limit_amount" validate:"required,min=1"`
}

// ---------------------------------------------------------------- Responses

type Status string

const (
	StatusOK       Status = "OK"
	StatusWarning  Status = "WARNING"  // from 80%
	StatusExceeded Status = "EXCEEDED" // above 100%
)

// BudgetResponse is a month's budget with its progress, calculated from
// transactions.
type BudgetResponse struct {
	Month           string  `json:"month"`
	LimitAmount     int64   `json:"limit_amount"`
	Spent           int64   `json:"spent"`
	Remaining       int64   `json:"remaining"` // negative when over budget
	ProgressPercent float64 `json:"progress_percent"`
	Status          Status  `json:"status"`
}
