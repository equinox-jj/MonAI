package category

import (
	"time"

	"github.com/google/uuid"
)

type Type string

const (
	TypeExpense Type = "EXPENSE"
	TypeIncome  Type = "INCOME"
)

type Category struct {
	ID        uuid.UUID `gorm:"column:id;type:uuid;primaryKey;default:gen_random_uuid()"`
	UserID    uuid.UUID `gorm:"column:user_id;type:uuid;not null"`
	Name      string    `gorm:"column:name;size:30;not null"`
	Type      Type      `gorm:"column:type;size:10;not null"`
	Icon      *string   `gorm:"column:icon;size:50"`
	Color     *string   `gorm:"column:color;size:7"`
	IsDefault bool      `gorm:"column:is_default;not null;default:false"`
	IsSystem  bool      `gorm:"column:is_system;not null;default:false"`
	IsHidden  bool      `gorm:"column:is_hidden;not null;default:false"`
	CreatedAt time.Time `gorm:"column:created_at"`
	UpdatedAt time.Time `gorm:"column:updated_at"`
}

func (Category) TableName() string { return "categories" }
