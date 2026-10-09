package provider

// logoURLFunc turns a stored logo key into its public URL (nil stays nil).
type logoURLFunc func(key *string) *string

// ToProviderResponse maps a provider to the public catalog shape.
func ToProviderResponse(p *PaymentProvider, logoURL logoURLFunc) ProviderResponse {
	aliases := make([]string, len(p.Aliases))
	for i, a := range p.Aliases {
		aliases[i] = a.Alias
	}

	return ProviderResponse{
		ID:        p.ID,
		Slug:      p.Slug,
		Name:      p.Name,
		Type:      p.Type,
		LogoURL:   logoURL(p.LogoKey),
		Aliases:   aliases,
		SortOrder: p.SortOrder,
	}
}

// ToProviderResponses maps ps, returning [] (never nil) when ps is empty.
func ToProviderResponses(ps []PaymentProvider, logoURL logoURLFunc) []ProviderResponse {
	out := make([]ProviderResponse, len(ps))
	for i := range ps {
		out[i] = ToProviderResponse(&ps[i], logoURL)
	}
	return out
}

// ToAdminProviderResponse maps a provider to the admin shape.
func ToAdminProviderResponse(p *PaymentProvider, logoURL logoURLFunc) AdminProviderResponse {
	return AdminProviderResponse{
		ProviderResponse: ToProviderResponse(p, logoURL),
		IsActive:         p.IsActive,
		IsSystem:         p.IsSystem,
		CreatedBy:        p.CreatedBy,
		UpdatedBy:        p.UpdatedBy,
		CreatedAt:        p.CreatedAt.UTC(),
		UpdatedAt:        p.UpdatedAt.UTC(),
	}
}

// ToAdminProviderResponses maps ps, returning [] (never nil) when ps is empty.
func ToAdminProviderResponses(ps []PaymentProvider, logoURL logoURLFunc) []AdminProviderResponse {
	out := make([]AdminProviderResponse, len(ps))
	for i := range ps {
		out[i] = ToAdminProviderResponse(&ps[i], logoURL)
	}
	return out
}
