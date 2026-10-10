package gemini

import "github.com/equinox-jj/MonAI/backend/internal/ai"

// The JSON shapes the schemas in schema.go produce.
type (
	transactionResponse struct {
		Drafts []draft `json:"drafts"`
	}

	receiptResponse struct {
		Draft struct {
			draft
			Items []item `json:"items"`
		} `json:"draft"`
	}

	draft struct {
		Type       *string `json:"type"`
		Amount     *int64  `json:"amount"`
		WalletID   *string `json:"wallet_id"`
		ToWalletID *string `json:"to_wallet_id"`
		CategoryID *string `json:"category_id"`
		Date       *string `json:"date"`
		Note       *string `json:"note"`
		Merchant   *string `json:"merchant"`
		Confidence struct {
			Type     float64 `json:"type"`
			Amount   float64 `json:"amount"`
			Wallet   float64 `json:"wallet"`
			Category float64 `json:"category"`
			Date     float64 `json:"date"`
		} `json:"confidence"`
	}

	item struct {
		Name     string   `json:"name"`
		Quantity *float64 `json:"quantity"`
		Amount   *int64   `json:"amount"`
	}
)

func (d draft) toRaw() ai.RawDraft {
	return ai.RawDraft{
		Type:       d.Type,
		Amount:     d.Amount,
		WalletID:   d.WalletID,
		ToWalletID: d.ToWalletID,
		CategoryID: d.CategoryID,
		Date:       d.Date,
		Note:       d.Note,
		Merchant:   d.Merchant,
		Confidence: ai.RawConfidence(d.Confidence),
	}
}

func (r transactionResponse) toRaw() []ai.RawDraft {
	out := make([]ai.RawDraft, 0, len(r.Drafts))
	for _, d := range r.Drafts {
		out = append(out, d.toRaw())
	}

	return out
}

func (r receiptResponse) toRaw() ai.RawReceiptDraft {
	items := make([]ai.RawReceiptItem, 0, len(r.Draft.Items))
	for _, it := range r.Draft.Items {
		items = append(items, ai.RawReceiptItem(it))
	}

	return ai.RawReceiptDraft{RawDraft: r.Draft.draft.toRaw(), Items: items}
}
