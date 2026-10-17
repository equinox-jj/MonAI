package report

import (
	"context"
	"math"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/period"
)

type Service interface {
	// Monthly returns the report for month (YYYY-MM) compared with the
	// previous month, or ErrMonthInvalid.
	Monthly(ctx context.Context, userID uuid.UUID, month string) (MonthlyReportResponse, error)
}

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo: repo}
}

func (s *service) Monthly(ctx context.Context, userID uuid.UUID, month string) (MonthlyReportResponse, error) {
	from, to, err := period.Month(month)
	if err != nil {
		return MonthlyReportResponse{}, ErrMonthInvalid
	}
	prevFrom := from.AddDate(0, -1, 0)

	cur, prev, err := s.repo.Totals(ctx, userID, prevFrom, from, to)
	if err != nil {
		return MonthlyReportResponse{}, err
	}
	cats, err := s.repo.ExpenseByCategory(ctx, userID, prevFrom, from, to)
	if err != nil {
		return MonthlyReportResponse{}, err
	}

	return MonthlyReportResponse{
		Month:        from.Format(period.MonthLayout),
		IncomeTotal:  cur.Income,
		ExpenseTotal: cur.Expense,
		Net:          cur.Income - cur.Expense,
		Previous: PreviousMonth{
			Month:        prevFrom.Format(period.MonthLayout),
			IncomeTotal:  prev.Income,
			ExpenseTotal: prev.Expense,
		},
		ExpenseChangePercent: change(cur.Expense, prev.Expense),
		Categories:           breakdown(cats, cur.Expense),
	}, nil
}

// breakdown maps the category amounts, already in report order, adding each
// category's share of the month's expenses and its change from the previous
// month.
func breakdown(cats []CategoryAmount, expenseTotal int64) []CategoryBreakdown {
	out := make([]CategoryBreakdown, len(cats))
	for i, c := range cats {
		out[i] = CategoryBreakdown{
			CategoryID:     c.CategoryID,
			Name:           c.Name,
			Icon:           c.Icon,
			Color:          c.Color,
			Amount:         c.Amount,
			SharePercent:   percent(c.Amount, expenseTotal),
			PreviousAmount: c.PreviousAmount,
			ChangePercent:  change(c.Amount, c.PreviousAmount),
		}
	}

	return out
}

// percent returns part as a percentage of whole, rounded to one decimal, or 0
// when whole is 0.
func percent(part, whole int64) float64 {
	if whole == 0 {
		return 0
	}

	return math.Round(float64(part)*1000/float64(whole)) / 10
}

// change returns the percentage change from prev to cur, or nil when prev is 0.
func change(cur, prev int64) *float64 {
	if prev == 0 {
		return nil
	}
	p := percent(cur-prev, prev)

	return &p
}
