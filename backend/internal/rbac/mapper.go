package rbac

// ToRoleSummary maps a role entity to the summary embedded in the user profile.
func ToRoleSummary(r *Role) RoleSummary {
	return RoleSummary{
		Slug: r.Slug,
		Name: r.Name,
	}
}

// ToPermissionResponse maps a permission entity to the API shape.
func ToPermissionResponse(p *Permission) PermissionResponse {
	return PermissionResponse{
		ID:          p.ID,
		Code:        p.Code,
		Description: p.Description,
	}
}

// ToPermissionResponses maps permission entities to the API shape. It never
// returns nil, so an empty list serializes as [].
func ToPermissionResponses(ps []Permission) []PermissionResponse {
	out := make([]PermissionResponse, 0, len(ps))
	for i := range ps {
		out = append(out, ToPermissionResponse(&ps[i]))
	}
	return out
}

// ToRoleResponse maps a role to the API shape. permissions are the role's
// permission codes (from ListPermissionCodes or the per-role cache).
func ToRoleResponse(r *Role, permissions []string) RoleResponse {
	if permissions == nil {
		permissions = []string{}
	}
	return RoleResponse{
		ID:          r.ID,
		Slug:        r.Slug,
		Name:        r.Name,
		Description: r.Description,
		IsSystem:    r.IsSystem,
		IsDefault:   r.IsDefault,
		Permissions: permissions,
		CreatedAt:   r.CreatedAt.UTC(),
		UpdatedAt:   r.UpdatedAt.UTC(),
	}
}
