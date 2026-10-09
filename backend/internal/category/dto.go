package category

import (
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// ---------------------------------------------------------------- Requests

// ListCategoriesQuery is the query of GET /categories.
type ListCategoriesQuery struct {
	Type          *Type `query:"type" validate:"omitempty,oneof=EXPENSE INCOME"`
	IncludeHidden bool  `query:"include_hidden"`
}

// CreateCategoryRequest is the body of POST /categories.
type CreateCategoryRequest struct {
	Name  string  `json:"name" validate:"required,min=1,max=30"`
	Type  Type    `json:"type" validate:"required,oneof=EXPENSE INCOME"`
	Icon  *string `json:"icon" validate:"omitempty,max=50"`
	Color *string `json:"color" validate:"omitempty,len=7,hexcolor"`
}

// UpdateCategoryRequest is the body of PATCH /categories/{id}. Absent fields
// are left unchanged; icon and color accept null to clear them.
type UpdateCategoryRequest struct {
	Name     *string                 `json:"name" validate:"omitempty,min=1,max=30"`
	Icon     httpx.Optional[*string] `json:"icon" validate:"omitempty,max=50"`
	Color    httpx.Optional[*string] `json:"color" validate:"omitempty,len=7,hexcolor"`
	IsHidden *bool                   `json:"is_hidden"`
}

// empty reports whether no field was sent (spec: minProperties 1).
func (r UpdateCategoryRequest) empty() bool {
	return r.Name == nil && !r.Icon.Set && !r.Color.Set && r.IsHidden == nil
}

// ---------------------------------------------------------------- Responses

// CategoryResponse is a category as returned by the API.
type CategoryResponse struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	Type      Type      `json:"type"`
	Icon      *string   `json:"icon"`
	Color     *string   `json:"color"`
	IsDefault bool      `json:"is_default"`
	IsSystem  bool      `json:"is_system"`
	IsHidden  bool      `json:"is_hidden"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
