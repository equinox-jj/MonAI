package ai

import (
	"context"

	"github.com/google/uuid"
)

// TransactionParser turns free text into raw transaction drafts. It is the
// only part that talks to an AI provider; implementations live in
// subpackages (ai/gemini) and are chosen in cmd/api. Provider failures
// (rate limits, timeouts, 5xx, unparseable output) must wrap ErrUnavailable.
type TransactionParser interface {
	ParseTransaction(ctx context.Context, in ParseInput) ([]RawDraft, error)
	// ParseReceipt reads in.Text as receipt OCR text.
	ParseReceipt(ctx context.Context, in ParseInput) (RawReceiptDraft, error)
}

// ParseInput is everything sent to the provider: the minimum the model needs
// to fill a draft, as ID-name pairs. Never add balances or other user data.
type ParseInput struct {
	Text       string
	Today      string // YYYY-MM-DD, the user's local date
	Timezone   string
	Wallets    []WalletRef
	Categories []CategoryRef
}

type WalletRef struct {
	ID      uuid.UUID
	Name    string
	Aliases []string // the provider's aliases, e.g. "gopay", "gpay"
}

type CategoryRef struct {
	ID   uuid.UUID
	Name string
	Type string // EXPENSE or INCOME
}

// RawDraft is the provider's untrusted output. The service validates every
// field before it reaches the client.
type RawDraft struct {
	Type       *string
	Amount     *int64
	WalletID   *string
	ToWalletID *string
	CategoryID *string
	Date       *string
	Note       *string
	Merchant   *string
	Confidence RawConfidence
}

type RawConfidence struct {
	Type     float64
	Amount   float64
	Wallet   float64
	Category float64
	Date     float64
}

type RawReceiptDraft struct {
	RawDraft
	Items []RawReceiptItem
}

type RawReceiptItem struct {
	Name     string
	Quantity *float64
	Amount   *int64
}
