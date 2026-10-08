package transaction

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Type string

const (
	TypeExpense  Type = "EXPENSE"
	TypeIncome   Type = "INCOME"
	TypeTransfer Type = "TRANSFER"
)

type Source string

const (
	SourceManual   Source = "MANUAL"
	SourceQuickAdd Source = "QUICK_ADD"
	SourceReceipt  Source = "RECEIPT"
)

type Transaction struct {
	ID         uuid.UUID      `gorm:"column:id;type:uuid;primaryKey;default:gen_random_uuid()"`
	UserID     uuid.UUID      `gorm:"column:user_id;type:uuid;not null"`
	Type       Type           `gorm:"column:type;size:10;not null"`
	Amount     int64          `gorm:"column:amount;not null"`
	WalletID   uuid.UUID      `gorm:"column:wallet_id;type:uuid;not null"`
	ToWalletID *uuid.UUID     `gorm:"column:to_wallet_id;type:uuid"`  // transfers only
	CategoryID *uuid.UUID     `gorm:"column:category_id;type:uuid"`   // expense and income only
	Date       time.Time      `gorm:"column:date;type:date;not null"` // user's local date
	Note       *string        `gorm:"column:note;size:200"`
	Merchant   *string        `gorm:"column:merchant;size:100"`
	ReceiptKey *string        `gorm:"column:receipt_key;size:255"`
	Source     Source         `gorm:"column:source;size:10;not null;default:MANUAL"`
	CreatedAt  time.Time      `gorm:"column:created_at"`
	UpdatedAt  time.Time      `gorm:"column:updated_at"`
	DeletedAt  gorm.DeletedAt `gorm:"column:deleted_at"`
}

func (Transaction) TableName() string { return "transactions" }
