package rbac

// ---------------------------------------------------------------- Responses

// RoleSummary is a role's public identity, embedded in the user profile.
type RoleSummary struct {
	Slug string `json:"slug"`
	Name string `json:"name"`
}
