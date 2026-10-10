package report

import "github.com/google/uuid"

// Totals is the income and expense sum for a date range.
type Totals struct {
	Income  int64
	Expense int64
}

// CategoryAmount is one expense category's sum for the report month and for
// the previous month.
type CategoryAmount struct {
	CategoryID     uuid.UUID
	Name           string
	Icon           *string
	Color          *string
	Amount         int64
	PreviousAmount int64
}
