package provider

import (
	"time"

	"github.com/google/uuid"
)

// ---------------------------------------------------------------- Requests

// Status filter values of GET /admin/payment-providers.
const (
	StatusActive   = "ACTIVE"
	StatusInactive = "INACTIVE"
	StatusAll      = "ALL"
)

// ListProvidersQuery is the query of GET /admin/payment-providers.
type ListProvidersQuery struct {
	Page    int    `json:"page" query:"page" validate:"omitempty,min=1"`
	PerPage int    `json:"per_page" query:"per_page" validate:"omitempty,min=1,max=100"`
	Q       string `json:"q" query:"q" validate:"omitempty,max=50"`
	Status  string `json:"status" query:"status" validate:"omitempty,oneof=ACTIVE INACTIVE ALL"`
	Type    *Type  `json:"type" query:"type" validate:"omitempty,oneof=CASH BANK E_WALLET OTHER"`
}

// CreateProviderRequest is the body of POST /admin/payment-providers. The
// slug is generated from the name when omitted.
type CreateProviderRequest struct {
	Name      string   `json:"name" validate:"required,min=1,max=50"`
	Slug      *string  `json:"slug" validate:"omitempty,max=50"`
	Type      Type     `json:"type" validate:"required,oneof=CASH BANK E_WALLET OTHER"`
	Aliases   []string `json:"aliases" validate:"omitempty,max=20,dive,min=1,max=50"`
	SortOrder int      `json:"sort_order" validate:"min=-2147483648,max=2147483647"`
}

// UpdateProviderRequest is the body of PATCH /admin/payment-providers/{id}.
// Absent fields are left unchanged; aliases, when sent, replaces the list.
type UpdateProviderRequest struct {
	Name      *string   `json:"name" validate:"omitempty,min=1,max=50"`
	Slug      *string   `json:"slug" validate:"omitempty,max=50"`
	Type      *Type     `json:"type" validate:"omitempty,oneof=CASH BANK E_WALLET OTHER"`
	Aliases   *[]string `json:"aliases" validate:"omitempty,max=20,dive,min=1,max=50"`
	SortOrder *int      `json:"sort_order" validate:"omitempty,min=-2147483648,max=2147483647"`
}

// empty reports whether no field was sent (spec: minProperties 1).
func (r UpdateProviderRequest) empty() bool {
	return r.Name == nil && r.Slug == nil && r.Type == nil && r.Aliases == nil && r.SortOrder == nil
}

// ProviderStatusRequest is the body of PATCH /admin/payment-providers/{id}/status.
type ProviderStatusRequest struct {
	IsActive *bool `json:"is_active" validate:"required"`
}

// ---------------------------------------------------------------- Responses

// ProviderResponse is a provider in the public catalog.
type ProviderResponse struct {
	ID        uuid.UUID `json:"id"`
	Slug      string    `json:"slug"`
	Name      string    `json:"name"`
	Type      Type      `json:"type"`
	LogoURL   *string   `json:"logo_url"`
	Aliases   []string  `json:"aliases"`
	SortOrder int       `json:"sort_order"`
}

// AdminProviderResponse is a provider as returned by the admin endpoints.
type AdminProviderResponse struct {
	ProviderResponse
	IsActive  bool       `json:"is_active"`
	IsSystem  bool       `json:"is_system"`
	CreatedBy *uuid.UUID `json:"created_by"`
	UpdatedBy *uuid.UUID `json:"updated_by"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
}

// ProviderCatalogResponse is the body of GET /payment-providers.
type ProviderCatalogResponse struct {
	Version   int64              `json:"version"`
	Providers []ProviderResponse `json:"providers"`
}
