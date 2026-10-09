package wallet

// logoURLFunc turns a stored logo key into its public URL (nil stays nil).
type logoURLFunc func(key *string) *string

// ToWalletResponse maps a wallet with its balance to the API shape.
func ToWalletResponse(d *Detail, logoURL logoURLFunc) WalletResponse {
	return WalletResponse{
		ID:             d.ID,
		ProviderID:     d.ProviderID,
		Name:           d.Name,
		Type:           d.Type,
		LogoURL:        logoURL(d.LogoKey),
		InitialBalance: d.InitialBalance,
		CurrentBalance: d.CurrentBalance,
		Icon:           d.Icon,
		Color:          d.Color,
		IsDefault:      d.IsDefault,
		IsArchived:     d.IsArchived,
		CreatedAt:      d.CreatedAt.UTC(),
		UpdatedAt:      d.UpdatedAt.UTC(),
	}
}

// ToWalletResponses maps ds, returning [] (never nil) when ds is empty.
func ToWalletResponses(ds []Detail, logoURL logoURLFunc) []WalletResponse {
	out := make([]WalletResponse, len(ds))
	for i := range ds {
		out[i] = ToWalletResponse(&ds[i], logoURL)
	}
	return out
}
