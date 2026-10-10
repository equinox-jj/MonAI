package report

import (
	"context"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

// Repository holds read-only queries. It reads the transactions and categories
// tables directly to avoid importing those feature packages. Each query covers
// the report month [from, to) and the previous month [prevFrom, from) in one
// pass.
type Repository interface {
	// Totals sums the user's non-deleted INCOME and EXPENSE amounts for both
	// months. Transfers are excluded.
	Totals(ctx context.Context, userID uuid.UUID, prevFrom, from, to time.Time) (cur, prev Totals, err error)
	// ExpenseByCategory sums the user's non-deleted EXPENSE amounts per
	// category for both months. Rows are sorted by amount descending; those
	// spent on only in the previous month come last, by previous amount
	// descending; ties by name.
	ExpenseByCategory(ctx context.Context, userID uuid.UUID, prevFrom, from, to time.Time) ([]CategoryAmount, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) Totals(ctx context.Context, userID uuid.UUID, prevFrom, from, to time.Time) (cur, prev Totals, err error) {
	var row struct {
		Income, Expense, PrevIncome, PrevExpense int64
	}
	err = database.Conn(ctx, r.db).
		Raw(`SELECT
				COALESCE(SUM(amount) FILTER (WHERE type = 'INCOME'  AND date >= @from), 0) AS income,
				COALESCE(SUM(amount) FILTER (WHERE type = 'EXPENSE' AND date >= @from), 0) AS expense,
				COALESCE(SUM(amount) FILTER (WHERE type = 'INCOME'  AND date <  @from), 0) AS prev_income,
				COALESCE(SUM(amount) FILTER (WHERE type = 'EXPENSE' AND date <  @from), 0) AS prev_expense
			FROM transactions
			WHERE user_id = @user AND deleted_at IS NULL AND date >= @prevFrom AND date < @to`,
			map[string]any{"user": userID, "prevFrom": prevFrom, "from": from, "to": to}).
		Scan(&row).Error

	return Totals{Income: row.Income, Expense: row.Expense},
		Totals{Income: row.PrevIncome, Expense: row.PrevExpense}, err
}

func (r *repository) ExpenseByCategory(ctx context.Context, userID uuid.UUID, prevFrom, from, to time.Time) ([]CategoryAmount, error) {
	rows := []CategoryAmount{}
	err := database.Conn(ctx, r.db).
		Raw(`SELECT c.id AS category_id, c.name, c.icon, c.color,
				COALESCE(SUM(t.amount) FILTER (WHERE t.date >= @from), 0) AS amount,
				COALESCE(SUM(t.amount) FILTER (WHERE t.date <  @from), 0) AS previous_amount
			FROM transactions t
			JOIN categories c ON c.id = t.category_id AND c.user_id = t.user_id
			WHERE t.user_id = @user AND t.type = 'EXPENSE' AND t.deleted_at IS NULL
			AND t.date >= @prevFrom AND t.date < @to
			GROUP BY c.id
			ORDER BY amount DESC, CASE WHEN SUM(t.amount) FILTER (WHERE t.date >= @from) IS NULL
				THEN SUM(t.amount) END DESC NULLS LAST, c.name`,
			map[string]any{"user": userID, "prevFrom": prevFrom, "from": from, "to": to}).
		Scan(&rows).Error

	return rows, err
}
