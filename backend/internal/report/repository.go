package report

import (
	"context"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

// Repository holds read-only queries. It reads the transactions and categories
// tables directly to avoid importing those feature packages.
type Repository interface {
	// Totals sums the user's non-deleted INCOME and EXPENSE amounts with a
	// date in the half-open range [from, to). Transfers are excluded.
	Totals(ctx context.Context, userID uuid.UUID, from, to time.Time) (Totals, error)
	// ExpenseByCategory sums the user's non-deleted EXPENSE amounts with a date
	// in [from, to) per category, sorted by amount descending.
	ExpenseByCategory(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]CategoryAmount, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) Totals(ctx context.Context, userID uuid.UUID, from, to time.Time) (Totals, error) {
	var t Totals
	err := database.Conn(ctx, r.db).
		Raw(`SELECT COALESCE(SUM(amount) FILTER (WHERE type = 'INCOME'), 0) AS income,
			COALESCE(SUM(amount) FILTER (WHERE type = 'EXPENSE'), 0) AS expense
			FROM transactions
			WHERE user_id = ? AND deleted_at IS NULL AND date >= ? AND date < ?`, userID, from, to).
		Scan(&t).Error

	return t, err
}

func (r *repository) ExpenseByCategory(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]CategoryAmount, error) {
	rows := []CategoryAmount{}
	err := database.Conn(ctx, r.db).
		Raw(`SELECT c.id AS category_id, c.name, c.icon, c.color, SUM(t.amount) AS amount
			FROM transactions t
			JOIN categories c ON c.id = t.category_id AND c.user_id = t.user_id
			WHERE t.user_id = ? AND t.type = 'EXPENSE' AND t.deleted_at IS NULL
			AND t.date >= ? AND t.date < ?
			GROUP BY c.id
			ORDER BY amount DESC, c.name`, userID, from, to).
		Scan(&rows).Error

	return rows, err
}
