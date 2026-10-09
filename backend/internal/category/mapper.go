package category

// ToCategoryResponse maps a category to the API shape.
func ToCategoryResponse(c *Category) CategoryResponse {
	return CategoryResponse{
		ID:        c.ID,
		Name:      c.Name,
		Type:      c.Type,
		Icon:      c.Icon,
		Color:     c.Color,
		IsDefault: c.IsDefault,
		IsSystem:  c.IsSystem,
		IsHidden:  c.IsHidden,
		CreatedAt: c.CreatedAt.UTC(),
		UpdatedAt: c.UpdatedAt.UTC(),
	}
}

// ToCategoryResponses maps cs, returning [] (never nil) when cs is empty.
func ToCategoryResponses(cs []Category) []CategoryResponse {
	out := make([]CategoryResponse, len(cs))
	for i := range cs {
		out[i] = ToCategoryResponse(&cs[i])
	}
	return out
}
