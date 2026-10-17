package wallet

import (
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// ---------------------------------------------------------------- Requests

// ListWalletsQuery is the query of GET /wallets.
type ListWalletsQuery struct {
	IncludeArchived bool `json:"include_archived" query:"include_archived"`
}

// CreateWalletRequest is the body of POST /wallets. With provider_id set,
// name and type default to the provider's values; otherwise both are
// required.
type CreateWalletRequest struct {
	ProviderID     *uuid.UUID `json:"provider_id"`
	Name           *string    `json:"name" validate:"omitempty,min=1,notblank,max=30"`
	Type           *Type      `json:"type" validate:"omitempty,oneof=CASH BANK E_WALLET OTHER"`
	InitialBalance int64      `json:"initial_balance" validate:"min=0,max=999999999999999"`
	Icon           *string    `json:"icon" validate:"omitempty,max=50"`
	Color          *string    `json:"color" validate:"omitempty,len=7,hexcolor"`
	IsDefault      bool       `json:"is_default"`
}

// UpdateWalletRequest is the body of PATCH /wallets/{id}. Absent fields are
// left unchanged; icon and color accept null to clear them.
type UpdateWalletRequest struct {
	Name           *string                 `json:"name" validate:"omitempty,min=1,notblank,max=30"`
	Type           *Type                   `json:"type" validate:"omitempty,oneof=CASH BANK E_WALLET OTHER"`
	InitialBalance *int64                  `json:"initial_balance" validate:"omitempty,min=0,max=999999999999999"`
	Icon           httpx.Optional[*string] `json:"icon" validate:"omitempty,max=50"`
	Color          httpx.Optional[*string] `json:"color" validate:"omitempty,len=7,hexcolor"`
	IsDefault      *bool                   `json:"is_default"`
	IsArchived     *bool                   `json:"is_archived"`
}

// empty reports whether no field was sent (spec: minProperties 1).
func (r UpdateWalletRequest) empty() bool {
	return r.Name == nil && r.Type == nil && r.InitialBalance == nil &&
		!r.Icon.Set && !r.Color.Set && r.IsDefault == nil && r.IsArchived == nil
}

// ---------------------------------------------------------------- Responses

// WalletResponse is a wallet as returned by the API.
type WalletResponse struct {
	ID             uuid.UUID  `json:"id"`
	ProviderID     *uuid.UUID `json:"provider_id"`
	Name           string     `json:"name"`
	Type           Type       `json:"type"`
	LogoURL        *string    `json:"logo_url"`
	InitialBalance int64      `json:"initial_balance"`
	CurrentBalance int64      `json:"current_balance"`
	Icon           *string    `json:"icon"`
	Color          *string    `json:"color"`
	IsDefault      bool       `json:"is_default"`
	IsArchived     bool       `json:"is_archived"`
	CreatedAt      time.Time  `json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
}

// WalletListMeta is the meta of GET /wallets.
type WalletListMeta struct {
	// TotalBalance sums the current balances of non-archived wallets.
	TotalBalance int64 `json:"total_balance"`
}
