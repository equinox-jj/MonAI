package user

import (
	"time"

	"github.com/equinox-jj/MonAI/backend/internal/rbac"
)

// ToMeResponse maps a user and its role to the API shape. permissions are the
// role's permission codes (from the per-role cache), and avatarURL is the
// presigned GET URL for u.AvatarKey (nil when the user has no avatar).
func ToMeResponse(u *User, role *rbac.Role, permissions []string, avatarURL *string) MeResponse {
	if permissions == nil {
		permissions = []string{}
	}
	return MeResponse{
		ID:          u.ID,
		Name:        u.Name,
		Email:       u.Email,
		AvatarURL:   avatarURL,
		Role:        rbac.ToRoleSummary(role),
		Permissions: permissions,
		CreatedAt:   u.CreatedAt.UTC(),
	}
}

// ToUploadURLResponse builds the presigned avatar upload response for a PUT URL.
func ToUploadURLResponse(uploadURL, objectKey, contentType string, expiresIn time.Duration) UploadURLResponse {
	return UploadURLResponse{
		UploadURL: uploadURL,
		Method:    "PUT",
		Headers:   map[string]string{"Content-Type": contentType},
		ObjectKey: objectKey,
		ExpiresIn: int(expiresIn.Seconds()),
	}
}
