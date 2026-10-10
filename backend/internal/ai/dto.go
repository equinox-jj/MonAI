package ai

import "github.com/google/uuid"

type ParseTransactionRequest struct {
	Text     string `json:"text" validate:"required,min=1,max=300"`
	Today    string `json:"today" validate:"required,datetime=2006-01-02"`
	Timezone string `json:"timezone" validate:"required,timezone"`
}

type ParseReceiptRequest struct {
	OCRText  string `json:"ocr_text" validate:"required,min=1,max=5000"`
	Today    string `json:"today" validate:"required,datetime=2006-01-02"`
	Timezone string `json:"timezone" validate:"required,timezone"`
}

// TransactionDraft is a validated draft; unknown or invalid values are null.
type TransactionDraft struct {
	Type       *string         `json:"type"`
	Amount     *int64          `json:"amount"`
	WalletID   *uuid.UUID      `json:"wallet_id"`
	ToWalletID *uuid.UUID      `json:"to_wallet_id"`
	CategoryID *uuid.UUID      `json:"category_id"`
	Date       *string         `json:"date"`
	Note       *string         `json:"note"`
	Merchant   *string         `json:"merchant"`
	Confidence DraftConfidence `json:"confidence"`
}

// DraftConfidence is 0.0 to 1.0 per field. The client highlights fields
// below 0.7.
type DraftConfidence struct {
	Type     float64 `json:"type"`
	Amount   float64 `json:"amount"`
	Wallet   float64 `json:"wallet"`
	Category float64 `json:"category"`
	Date     float64 `json:"date"`
}

type ReceiptDraft struct {
	TransactionDraft
	Items []ReceiptItem `json:"items"`
}

type ReceiptItem struct {
	Name     string   `json:"name"`
	Quantity *float64 `json:"quantity"`
	Amount   *int64   `json:"amount"`
}

type ParseTransactionResponse struct {
	Drafts []TransactionDraft `json:"drafts"`
}

type ParseReceiptResponse struct {
	Draft ReceiptDraft `json:"draft"`
}
