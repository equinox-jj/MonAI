package rbac

import "time"

// Permission codes. Routes check these with RequirePermission, never role slugs.
const (
	PermProviderView   = "payment_provider.view"
	PermProviderCreate = "payment_provider.create"
	PermProviderUpdate = "payment_provider.update"
	PermProviderDelete = "payment_provider.delete"
)

// Seeded role slugs.
const (
	RoleUser  = "user"
	RoleAdmin = "admin"
)

type Role struct {
	ID          int64     `gorm:"column:id;primaryKey"`
	Slug        string    `gorm:"column:slug;size:50;not null"`
	Name        string    `gorm:"column:name;size:100;not null"`
	Description *string   `gorm:"column:description;type:text"`
	IsSystem    bool      `gorm:"column:is_system;not null;default:false"`
	IsDefault   bool      `gorm:"column:is_default;not null;default:false"`
	CreatedAt   time.Time `gorm:"column:created_at"`
	UpdatedAt   time.Time `gorm:"column:updated_at"`

	Permissions []Permission `gorm:"many2many:role_permissions"`
}

func (Role) TableName() string { return "roles" }

type Permission struct {
	ID          int64     `gorm:"column:id;primaryKey"`
	Code        string    `gorm:"column:code;size:100;not null"`
	Description *string   `gorm:"column:description;type:text"`
	CreatedAt   time.Time `gorm:"column:created_at"`
}

func (Permission) TableName() string { return "permissions" }

type RolePermission struct {
	RoleID       int64 `gorm:"column:role_id;primaryKey;autoIncrement:false"`
	PermissionID int64 `gorm:"column:permission_id;primaryKey;autoIncrement:false"`
}

func (RolePermission) TableName() string { return "role_permissions" }
