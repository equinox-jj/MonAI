package rbac

// ToRoleSummary maps a role entity to the summary embedded in the user profile.
func ToRoleSummary(r *Role) RoleSummary {
	return RoleSummary{
		Slug: r.Slug,
		Name: r.Name,
	}
}
