package rbac

import "time"

// ---------------------------------------------------------------- Responses

// RoleSummary is a role's public identity, embedded in the user profile.
type RoleSummary struct {
	Slug string `json:"slug"`
	Name string `json:"name"`
}

// PermissionResponse is a permission as exposed by the API.
type PermissionResponse struct {
	ID          int64   `json:"id"`
	Code        string  `json:"code"`
	Description *string `json:"description"` // null when unset
}

// RoleResponse is a role with its granted permission codes.
type RoleResponse struct {
	ID          int64     `json:"id"`
	Slug        string    `json:"slug"`
	Name        string    `json:"name"`
	Description *string   `json:"description"` // null when unset
	IsSystem    bool      `json:"is_system"`
	IsDefault   bool      `json:"is_default"`
	Permissions []string  `json:"permissions"` // sorted codes, [] when none
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}
