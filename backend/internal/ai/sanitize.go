package ai

import (
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/transaction"
)

// Limits on what a draft may carry, matching POST /transactions and the
// transactions columns, plus caps on runaway model output.
const (
	maxAmount   = 999_999_999_999
	maxNote     = 200
	maxMerchant = 100
	maxItemName = 100
	maxDrafts   = 10
	maxItems    = 100
)

// allowed holds the IDs the user owns, so a draft can only reference them.
type allowed struct {
	wallets    map[uuid.UUID]struct{}
	categories map[uuid.UUID]category.Type
	today      time.Time // the user's local date at UTC midnight
}

// sanitizeDrafts validates at most maxDrafts drafts. It never returns nil.
func (a allowed) sanitizeDrafts(raws []RawDraft) []TransactionDraft {
	raws = raws[:min(len(raws), maxDrafts)]
	out := make([]TransactionDraft, 0, len(raws))
	for _, r := range raws {
		out = append(out, a.sanitizeDraft(r))
	}

	return out
}

func (a allowed) sanitizeReceipt(raw RawReceiptDraft) ReceiptDraft {
	return ReceiptDraft{
		TransactionDraft: a.sanitizeDraft(raw.RawDraft),
		Items:            sanitizeItems(raw.Items),
	}
}

// sanitizeDraft turns every unknown or invalid field into null, with zero
// confidence, so the client asks the user to fill it in.
func (a allowed) sanitizeDraft(r RawDraft) TransactionDraft {
	d := TransactionDraft{
		Note:     text(r.Note, maxNote),
		Merchant: text(r.Merchant, maxMerchant),
	}

	if t, ok := draftType(r.Type); ok {
		d.Type = &t
		d.Confidence.Type = confidence(r.Confidence.Type)
	}
	if r.Amount != nil && *r.Amount > 0 && *r.Amount <= maxAmount {
		d.Amount = r.Amount
		d.Confidence.Amount = confidence(r.Confidence.Amount)
	}
	if id, ok := a.wallet(r.WalletID); ok {
		d.WalletID = &id
		d.Confidence.Wallet = confidence(r.Confidence.Wallet)
	}
	if d.Type != nil && *d.Type == string(transaction.TypeTransfer) {
		// A transfer has no category; the wallet confidence covers both wallets.
		if id, ok := a.wallet(r.ToWalletID); ok && (d.WalletID == nil || id != *d.WalletID) {
			d.ToWalletID = &id
		}
	} else if id, ok := a.category(r.CategoryID, d.Type); ok {
		d.CategoryID = &id
		d.Confidence.Category = confidence(r.Confidence.Category)
	}
	if date, ok := a.date(r.Date); ok {
		d.Date = &date
		d.Confidence.Date = confidence(r.Confidence.Date)
	}

	return d
}

func (a allowed) wallet(v *string) (uuid.UUID, bool) {
	id, ok := parseID(v)
	if !ok {
		return uuid.Nil, false
	}
	_, ok = a.wallets[id]

	return id, ok
}

// category accepts an owned category whose type matches the draft's type.
// With no type yet, any owned category is kept.
func (a allowed) category(v *string, draftType *string) (uuid.UUID, bool) {
	id, ok := parseID(v)
	if !ok {
		return uuid.Nil, false
	}
	t, ok := a.categories[id]
	if !ok || (draftType != nil && string(t) != *draftType) {
		return uuid.Nil, false
	}

	return id, true
}

// date accepts a YYYY-MM-DD date that is not after the user's today.
func (a allowed) date(v *string) (string, bool) {
	if v == nil {
		return "", false
	}
	d, err := time.Parse(time.DateOnly, strings.TrimSpace(*v))
	if err != nil || d.After(a.today) {
		return "", false
	}

	return d.Format(time.DateOnly), true
}

// sanitizeItems drops unnamed items and nulls non-positive numbers. It never
// returns nil.
func sanitizeItems(raws []RawReceiptItem) []ReceiptItem {
	out := make([]ReceiptItem, 0, min(len(raws), maxItems))
	for _, r := range raws {
		if len(out) == maxItems {
			break
		}
		name := text(&r.Name, maxItemName)
		if name == nil {
			continue
		}
		item := ReceiptItem{Name: *name}
		if r.Quantity != nil && *r.Quantity > 0 {
			item.Quantity = r.Quantity
		}
		if r.Amount != nil && *r.Amount > 0 && *r.Amount <= maxAmount {
			item.Amount = r.Amount
		}
		out = append(out, item)
	}

	return out
}

func draftType(v *string) (string, bool) {
	if v == nil {
		return "", false
	}
	switch t := transaction.Type(strings.ToUpper(strings.TrimSpace(*v))); t {
	case transaction.TypeExpense, transaction.TypeIncome, transaction.TypeTransfer:
		return string(t), true
	}

	return "", false
}

func parseID(v *string) (uuid.UUID, bool) {
	if v == nil {
		return uuid.Nil, false
	}
	id, err := uuid.Parse(strings.TrimSpace(*v))

	return id, err == nil
}

// text trims v and cuts it to n runes; empty becomes nil.
func text(v *string, n int) *string {
	if v == nil {
		return nil
	}
	s := strings.TrimSpace(*v)
	if r := []rune(s); len(r) > n {
		s = strings.TrimSpace(string(r[:n]))
	}
	if s == "" {
		return nil
	}

	return &s
}

// confidence clamps c to [0, 1].
func confidence(c float64) float64 {
	return max(0, min(1, c))
}
