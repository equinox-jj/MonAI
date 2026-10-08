package user

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID           uuid.UUID `gorm:"column:id;type:uuid;primaryKey;default:gen_random_uuid()"`
	Name         string    `gorm:"column:name;size:100;not null"`
	Email        string    `gorm:"column:email;size:254;not null"` // stored lowercase
	PasswordHash string    `gorm:"column:password_hash;size:100;not null"`
	AvatarKey    *string   `gorm:"column:avatar_key;size:255"`
	RoleID       int64     `gorm:"column:role_id;not null"`
	CreatedAt    time.Time `gorm:"column:created_at"`
	UpdatedAt    time.Time `gorm:"column:updated_at"`
}

func (User) TableName() string { return "users" }
