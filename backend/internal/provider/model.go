package provider

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Type string

const (
	TypeCash    Type = "CASH"
	TypeBank    Type = "BANK"
	TypeEWallet Type = "E_WALLET"
	TypeOther   Type = "OTHER"
)

// CatalogName is the catalog_versions row bumped on every provider change.
const CatalogName = "payment_providers"

type PaymentProvider struct {
	ID        uuid.UUID      `gorm:"column:id;type:uuid;primaryKey;default:gen_random_uuid()"`
	Slug      string         `gorm:"column:slug;size:50;not null"`
	Name      string         `gorm:"column:name;size:50;not null"`
	Type      Type           `gorm:"column:type;size:10;not null"`
	LogoKey   *string        `gorm:"column:logo_key;size:255"`
	SortOrder int            `gorm:"column:sort_order;not null;default:0"`
	IsActive  bool           `gorm:"column:is_active;not null;default:true"`
	IsSystem  bool           `gorm:"column:is_system;not null;default:false"`
	CreatedBy *uuid.UUID     `gorm:"column:created_by;type:uuid"`
	UpdatedBy *uuid.UUID     `gorm:"column:updated_by;type:uuid"`
	CreatedAt time.Time      `gorm:"column:created_at"`
	UpdatedAt time.Time      `gorm:"column:updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"column:deleted_at"`

	Aliases []ProviderAlias `gorm:"foreignKey:ProviderID"`
}

func (PaymentProvider) TableName() string { return "payment_providers" }

type ProviderAlias struct {
	Alias      string    `gorm:"column:alias;size:50;primaryKey"` // stored lowercase
	ProviderID uuid.UUID `gorm:"column:provider_id;type:uuid;not null"`
}

func (ProviderAlias) TableName() string { return "provider_aliases" }

type CatalogVersion struct {
	Name      string    `gorm:"column:name;size:50;primaryKey"`
	Version   int64     `gorm:"column:version;not null;default:1"`
	UpdatedAt time.Time `gorm:"column:updated_at"`
}

func (CatalogVersion) TableName() string { return "catalog_versions" }
