package budget

import (
	"time"

	"github.com/google/uuid"
)

// Budget does not store progress; it is calculated from transactions.
type Budget struct {
	ID          uuid.UUID `gorm:"column:id;type:uuid;primaryKey;default:gen_random_uuid()"`
	UserID      uuid.UUID `gorm:"column:user_id;type:uuid;not null"`
	Month       string    `gorm:"column:month;type:char(7);not null"` // YYYY-MM
	LimitAmount int64     `gorm:"column:limit_amount;not null"`
	CreatedAt   time.Time `gorm:"column:created_at"`
	UpdatedAt   time.Time `gorm:"column:updated_at"`
}

func (Budget) TableName() string { return "budgets" }
