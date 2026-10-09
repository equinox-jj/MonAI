package user

import (
	"time"

	"github.com/google/uuid"
)

// Avatar upload limits (ERD §storage: expense-private/avatars/{user_id}/…).
const (
	AvatarMaxSizeBytes = 2 * 1024 * 1024
	AvatarURLExpiresIn = 15 * time.Minute
)

// ---------------------------------------------------------------- Requests

// UpdateMeRequest is the body of PATCH /me.
type UpdateMeRequest struct {
	Name string `json:"name" validate:"required,min=1,max=100"`
}

// DeleteAccountRequest is the body of DELETE /me.
type DeleteAccountRequest struct {
	Password string `json:"password" validate:"required"`
}

// AvatarUploadURLRequest is the body of POST /me/avatar/upload-url.
type AvatarUploadURLRequest struct {
	ContentType string `json:"content_type" validate:"required,oneof=image/jpeg image/png image/webp"`
	SizeBytes   int64  `json:"size_bytes" validate:"required,min=1,max=2097152"`
}

// ConfirmAvatarRequest is the body of PUT /me/avatar.
type ConfirmAvatarRequest struct {
	ObjectKey string `json:"object_key" validate:"required,max=255"`
}

// ---------------------------------------------------------------- Responses

// RoleSummary is the user's role as exposed in MeResponse.
type RoleSummary struct {
	Slug string `json:"slug"`
	Name string `json:"name"`
}

// MeResponse is the current user's profile, role and permissions. It is the data
// of GET/PATCH /me and PUT /me/avatar, and the user in the auth responses.
type MeResponse struct {
	ID          uuid.UUID   `json:"id"`
	Name        string      `json:"name"`
	Email       string      `json:"email"`
	AvatarURL   *string     `json:"avatar_url"` // presigned GET URL, null when unset
	Role        RoleSummary `json:"role"`
	Permissions []string    `json:"permissions"`
	CreatedAt   time.Time   `json:"created_at"`
}

// UploadURLResponse is a presigned PUT URL the client uploads the file to.
type UploadURLResponse struct {
	UploadURL string            `json:"upload_url"`
	Method    string            `json:"method"` // always PUT
	Headers   map[string]string `json:"headers"`
	ObjectKey string            `json:"object_key"`
	ExpiresIn int               `json:"expires_in"` // seconds
}
