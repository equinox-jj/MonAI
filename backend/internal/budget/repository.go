package budget

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
)

type Repository interface {
	// FindByMonth returns ErrNotFound when the user has no budget for month
	// (YYYY-MM).
	FindByMonth(ctx context.Context, userID uuid.UUID, month string) (*Budget, error)
	// Upsert inserts b, or updates limit_amount when the user already has a
	// budget for b.Month, and refreshes b from the stored row.
	Upsert(ctx context.Context, b *Budget) error
	// Delete returns ErrNotFound when the user has no budget for month.
	Delete(ctx context.Context, userID uuid.UUID, month string) error
	// SpentBetween sums the user's non-deleted EXPENSE amounts with a date in
	// the half-open range [from, to).
	SpentBetween(ctx context.Context, userID uuid.UUID, from, to time.Time) (int64, error)
}

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) FindByMonth(ctx context.Context, userID uuid.UUID, month string) (*Budget, error) {
	var b Budget
	if err := database.Conn(ctx, r.db).
		Where("user_id = ? AND month = ?", userID, month).
		First(&b).Error; err != nil {
		return nil, notFound(err)
	}

	return &b, nil
}

// Upsert is a single statement on the (user_id, month) unique key, so
// concurrent PUTs for the same month cannot race.
func (r *repository) Upsert(ctx context.Context, b *Budget) error {
	return database.Conn(ctx, r.db).
		Clauses(
			clause.OnConflict{
				Columns: []clause.Column{{Name: "user_id"}, {Name: "month"}},
				DoUpdates: clause.Assignments(map[string]any{
					"limit_amount": b.LimitAmount,
					"updated_at":   time.Now(),
				}),
			},
			clause.Returning{},
		).
		Create(b).Error
}

func (r *repository) Delete(ctx context.Context, userID uuid.UUID, month string) error {
	res := database.Conn(ctx, r.db).Delete(&Budget{}, "user_id = ? AND month = ?", userID, month)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotFound
	}

	return nil
}

// SpentBetween queries the transactions table directly to avoid importing the
// transaction package.
func (r *repository) SpentBetween(ctx context.Context, userID uuid.UUID, from, to time.Time) (int64, error) {
	var spent int64
	err := database.Conn(ctx, r.db).
		Raw(`SELECT COALESCE(SUM(amount), 0) FROM transactions
			WHERE user_id = ? AND type = 'EXPENSE' AND deleted_at IS NULL
			AND date >= ? AND date < ?`, userID, from, to).
		Scan(&spent).Error

	return spent, err
}

func notFound(err error) error {
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	}

	return err
}
