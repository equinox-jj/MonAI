package wallet

import (
	"time"

	"github.com/google/uuid"
)

type Type string

const (
	TypeCash    Type = "CASH"
	TypeBank    Type = "BANK"
	TypeEWallet Type = "E_WALLET"
	TypeOther   Type = "OTHER"
)

// Wallet does not store a balance; it is calculated from transactions.
type Wallet struct {
	ID             uuid.UUID  `gorm:"column:id;type:uuid;primaryKey;default:gen_random_uuid()"`
	UserID         uuid.UUID  `gorm:"column:user_id;type:uuid;not null"`
	ProviderID     *uuid.UUID `gorm:"column:provider_id;type:uuid"` // nil = custom wallet
	Name           string     `gorm:"column:name;size:30;not null"`
	Type           Type       `gorm:"column:type;size:10;not null"`
	InitialBalance int64      `gorm:"column:initial_balance;not null;default:0"`
	Icon           *string    `gorm:"column:icon;size:50"`
	Color          *string    `gorm:"column:color;size:7"`
	IsDefault      bool       `gorm:"column:is_default;not null;default:false"`
	IsArchived     bool       `gorm:"column:is_archived;not null;default:false"`
	CreatedAt      time.Time  `gorm:"column:created_at"`
	UpdatedAt      time.Time  `gorm:"column:updated_at"`
}

func (Wallet) TableName() string { return "wallets" }

// Detail is a wallet with its calculated balance and the provider's logo key
// (nil for custom wallets and deleted providers).
type Detail struct {
	Wallet         `gorm:"embedded"`
	LogoKey        *string `gorm:"column:logo_key"`
	CurrentBalance int64   `gorm:"column:current_balance"`
}
