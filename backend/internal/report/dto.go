package report

import "github.com/google/uuid"

// ---------------------------------------------------------------- Responses

// MonthlyReportResponse is a month's totals and expense breakdown compared
// with the previous month, calculated from transactions.
type MonthlyReportResponse struct {
	Month                string              `json:"month"`
	IncomeTotal          int64               `json:"income_total"`
	ExpenseTotal         int64               `json:"expense_total"`
	Net                  int64               `json:"net"`
	Previous             PreviousMonth       `json:"previous"`
	ExpenseChangePercent *float64            `json:"expense_change_percent"` // null when the previous expense is 0
	Categories           []CategoryBreakdown `json:"categories"`             // sorted by amount descending
}

type PreviousMonth struct {
	Month        string `json:"month"`
	IncomeTotal  int64  `json:"income_total"`
	ExpenseTotal int64  `json:"expense_total"`
}

type CategoryBreakdown struct {
	CategoryID     uuid.UUID `json:"category_id"`
	Name           string    `json:"name"`
	Icon           *string   `json:"icon"`
	Color          *string   `json:"color"`
	Amount         int64     `json:"amount"`
	SharePercent   float64   `json:"share_percent"`
	PreviousAmount int64     `json:"previous_amount"`
	ChangePercent  *float64  `json:"change_percent"` // null when previous_amount is 0
}
