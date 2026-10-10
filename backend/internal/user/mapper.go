package user

import (
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
		Timezone:    u.Timezone,
		Role:        rbac.ToRoleSummary(role),
		Permissions: permissions,
		CreatedAt:   u.CreatedAt.UTC(),
	}
}
