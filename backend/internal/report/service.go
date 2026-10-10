package report

import (
	"context"
	"math"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/period"
)

const monthLayout = "2006-01"

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

	cur, err := s.repo.Totals(ctx, userID, from, to)
	if err != nil {
		return MonthlyReportResponse{}, err
	}
	prev, err := s.repo.Totals(ctx, userID, prevFrom, from)
	if err != nil {
		return MonthlyReportResponse{}, err
	}
	curCats, err := s.repo.ExpenseByCategory(ctx, userID, from, to)
	if err != nil {
		return MonthlyReportResponse{}, err
	}
	prevCats, err := s.repo.ExpenseByCategory(ctx, userID, prevFrom, from)
	if err != nil {
		return MonthlyReportResponse{}, err
	}

	return MonthlyReportResponse{
		Month:        from.Format(monthLayout),
		IncomeTotal:  cur.Income,
		ExpenseTotal: cur.Expense,
		Net:          cur.Income - cur.Expense,
		Previous: PreviousMonth{
			Month:        prevFrom.Format(monthLayout),
			IncomeTotal:  prev.Income,
			ExpenseTotal: prev.Expense,
		},
		ExpenseChangePercent: change(cur.Expense, prev.Expense),
		Categories:           breakdown(curCats, prevCats, cur.Expense),
	}, nil
}

// breakdown merges the current and previous month's category amounts, both
// sorted by amount descending. Categories spent on only in the previous month
// are appended with amount 0, which keeps the result sorted.
func breakdown(cur, prev []CategoryAmount, expenseTotal int64) []CategoryBreakdown {
	prevAmount := make(map[uuid.UUID]int64, len(prev))
	for _, p := range prev {
		prevAmount[p.CategoryID] = p.Amount
	}

	out := make([]CategoryBreakdown, 0, len(cur)+len(prev))
	add := func(c CategoryAmount, amount, previous int64) {
		out = append(out, CategoryBreakdown{
			CategoryID:     c.CategoryID,
			Name:           c.Name,
			Icon:           c.Icon,
			Color:          c.Color,
			Amount:         amount,
			SharePercent:   percent(amount, expenseTotal),
			PreviousAmount: previous,
			ChangePercent:  change(amount, previous),
		})
	}

	for _, c := range cur {
		add(c, c.Amount, prevAmount[c.CategoryID])
		delete(prevAmount, c.CategoryID)
	}
	for _, p := range prev {
		if _, ok := prevAmount[p.CategoryID]; ok {
			add(p, 0, p.Amount)
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
