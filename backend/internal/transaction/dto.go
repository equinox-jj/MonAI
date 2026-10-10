package transaction

import (
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// Receipt limits (ERD §storage: expense-private/receipts/{user_id}/…).
// ReceiptURLExpiresIn is the lifetime of the presigned GET receipt_url.
const (
	ReceiptMaxSizeBytes = 5 * 1024 * 1024
	ReceiptURLExpiresIn = 15 * time.Minute
)

// Cursor list limits from the spec's Limit parameter.
const (
	DefaultLimit = 20
	MaxLimit     = 100
)

// dateLayout is the API's YYYY-MM-DD date format.
const dateLayout = time.DateOnly

// ---------------------------------------------------------------- Requests

// ListTransactionsQuery is the query of GET /transactions.
type ListTransactionsQuery struct {
	Month      string     `query:"month" validate:"omitempty,datetime=2006-01"`
	WalletID   *uuid.UUID `query:"wallet_id"`
	CategoryID *uuid.UUID `query:"category_id"`
	Type       *Type      `query:"type" validate:"omitempty,oneof=EXPENSE INCOME TRANSFER"`
	Q          string     `query:"q" validate:"omitempty,max=100"`
	Cursor     string     `query:"cursor"`
	Limit      int        `query:"limit" validate:"omitempty,min=1,max=100"`
}

// CreateTransactionRequest is the body of POST /transactions. Transfers need
// to_wallet_id and no category_id; expense and income the reverse.
type CreateTransactionRequest struct {
	Type       Type       `json:"type" validate:"required,oneof=EXPENSE INCOME TRANSFER"`
	Amount     int64      `json:"amount" validate:"required,min=1,max=999999999999"`
	WalletID   uuid.UUID  `json:"wallet_id" validate:"required"`
	ToWalletID *uuid.UUID `json:"to_wallet_id"`
	CategoryID *uuid.UUID `json:"category_id"`
	Date       string     `json:"date" validate:"required,datetime=2006-01-02"`
	Note       *string    `json:"note" validate:"omitempty,max=200"`
	Merchant   *string    `json:"merchant" validate:"omitempty,max=100"`
	ReceiptKey *string    `json:"receipt_key" validate:"omitempty,max=255"`
	Source     *Source    `json:"source" validate:"omitempty,oneof=MANUAL QUICK_ADD RECEIPT"`
}

// UpdateTransactionRequest is the body of PATCH /transactions/{id}. Absent
// fields are left unchanged; nullable fields accept null to clear them. The
// merged result must pass the same rules as create.
type UpdateTransactionRequest struct {
	Type       *Type                      `json:"type" validate:"omitempty,oneof=EXPENSE INCOME TRANSFER"`
	Amount     *int64                     `json:"amount" validate:"omitempty,min=1,max=999999999999"`
	WalletID   *uuid.UUID                 `json:"wallet_id"`
	ToWalletID httpx.Optional[*uuid.UUID] `json:"to_wallet_id"`
	CategoryID httpx.Optional[*uuid.UUID] `json:"category_id"`
	Date       *string                    `json:"date" validate:"omitempty,datetime=2006-01-02"`
	Note       httpx.Optional[*string]    `json:"note" validate:"omitempty,max=200"`
	Merchant   httpx.Optional[*string]    `json:"merchant" validate:"omitempty,max=100"`
	ReceiptKey httpx.Optional[*string]    `json:"receipt_key" validate:"omitempty,max=255"`
}

// empty reports whether no field was sent (spec: minProperties 1).
func (r UpdateTransactionRequest) empty() bool {
	return r.Type == nil && r.Amount == nil && r.WalletID == nil &&
		!r.ToWalletID.Set && !r.CategoryID.Set && r.Date == nil &&
		!r.Note.Set && !r.Merchant.Set && !r.ReceiptKey.Set
}

// ---------------------------------------------------------------- Responses

// TransactionResponse is a transaction as returned by the API.
type TransactionResponse struct {
	ID         uuid.UUID  `json:"id"`
	Type       Type       `json:"type"`
	Amount     int64      `json:"amount"`
	WalletID   uuid.UUID  `json:"wallet_id"`
	ToWalletID *uuid.UUID `json:"to_wallet_id"`
	CategoryID *uuid.UUID `json:"category_id"`
	Date       string     `json:"date"` // YYYY-MM-DD
	Note       *string    `json:"note"`
	Merchant   *string    `json:"merchant"`
	ReceiptURL *string    `json:"receipt_url"` // presigned GET URL, null when unset
	Source     Source     `json:"source"`
	CreatedAt  time.Time  `json:"created_at"`
	UpdatedAt  time.Time  `json:"updated_at"`
}

// ReceiptUploadResponse is the data of POST /transactions/receipt. The client
// passes ReceiptKey as receipt_key when creating or updating a transaction.
type ReceiptUploadResponse struct {
	ReceiptKey string `json:"receipt_key"`
}
