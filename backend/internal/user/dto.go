package user

import (
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/rbac"
)

// Avatar limits (ERD §storage: expense-private/avatars/{user_id}/…).
// AvatarURLExpiresIn is the lifetime of the presigned GET URL in MeResponse.
const (
	AvatarMaxSizeBytes = 2 * 1024 * 1024
	AvatarURLExpiresIn = 15 * time.Minute
)

// ---------------------------------------------------------------- Requests

// UpdateMeRequest is the body of PATCH /me. Absent fields are left unchanged.
type UpdateMeRequest struct {
	Name     *string `json:"name" validate:"omitempty,min=1,max=100"`
	Timezone *string `json:"timezone" validate:"omitempty,max=64,timezone"`
}

// empty reports whether no field was sent (spec: minProperties 1).
func (r UpdateMeRequest) empty() bool {
	return r.Name == nil && r.Timezone == nil
}

// DeleteAccountRequest is the body of DELETE /me.
type DeleteAccountRequest struct {
	Password string `json:"password" validate:"required"`
}

// ---------------------------------------------------------------- Responses

// MeResponse is the current user's profile, role and permissions. It is the data
// of GET/PATCH /me and PUT /me/avatar, and the user in the auth responses.
type MeResponse struct {
	ID          uuid.UUID        `json:"id"`
	Name        string           `json:"name"`
	Email       string           `json:"email"`
	AvatarURL   *string          `json:"avatar_url"` // presigned GET URL, null when unset
	Timezone    string           `json:"timezone"`
	Role        rbac.RoleSummary `json:"role"`
	Permissions []string         `json:"permissions"`
	CreatedAt   time.Time        `json:"created_at"`
}
