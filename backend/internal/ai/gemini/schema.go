package gemini

import (
	"google.golang.org/genai"

	"github.com/equinox-jj/MonAI/backend/internal/ai"
)

// draftFields lists a draft's properties in the order the model writes them.
var draftFields = []string{"type", "amount", "wallet_id", "to_wallet_id", "category_id", "date", "note", "merchant", "confidence"}

// transactionSchema is {"drafts": [draft]}.
func transactionSchema(in ai.ParseInput) *genai.Schema {
	return &genai.Schema{
		Type:     genai.TypeObject,
		Required: []string{"drafts"},
		Properties: map[string]*genai.Schema{
			"drafts": {Type: genai.TypeArray, Items: draftSchema(in)},
		},
	}
}

// receiptSchema is {"draft": draft + items}.
func receiptSchema(in ai.ParseInput) *genai.Schema {
	d := draftSchema(in)
	d.Properties["items"] = &genai.Schema{
		Type: genai.TypeArray,
		Items: &genai.Schema{
			Type:             genai.TypeObject,
			Required:         []string{"name", "quantity", "amount"},
			PropertyOrdering: []string{"name", "quantity", "amount"},
			Properties: map[string]*genai.Schema{
				"name":     {Type: genai.TypeString},
				"quantity": {Type: genai.TypeNumber, Nullable: genai.Ptr(true)},
				"amount":   {Type: genai.TypeInteger, Nullable: genai.Ptr(true)},
			},
		},
	}
	d.Required = append(d.Required, "items")
	d.PropertyOrdering = append(d.PropertyOrdering, "items")

	return &genai.Schema{
		Type:       genai.TypeObject,
		Required:   []string{"draft"},
		Properties: map[string]*genai.Schema{"draft": d},
	}
}

// draftSchema restricts the ID fields to the user's own IDs. The service
// still validates them; this only keeps the model from inventing values.
func draftSchema(in ai.ParseInput) *genai.Schema {
	walletIDs := make([]string, 0, len(in.Wallets))
	for _, w := range in.Wallets {
		walletIDs = append(walletIDs, w.ID.String())
	}
	categoryIDs := make([]string, 0, len(in.Categories))
	for _, c := range in.Categories {
		categoryIDs = append(categoryIDs, c.ID.String())
	}

	conf := &genai.Schema{Type: genai.TypeNumber, Minimum: genai.Ptr(0.0), Maximum: genai.Ptr(1.0)}

	return &genai.Schema{
		Type:             genai.TypeObject,
		Required:         append([]string(nil), draftFields...),
		PropertyOrdering: append([]string(nil), draftFields...),
		Properties: map[string]*genai.Schema{
			"type":         enum([]string{"EXPENSE", "INCOME", "TRANSFER"}),
			"amount":       {Type: genai.TypeInteger, Nullable: genai.Ptr(true)},
			"wallet_id":    enum(walletIDs),
			"to_wallet_id": enum(walletIDs),
			"category_id":  enum(categoryIDs),
			"date":         {Type: genai.TypeString, Nullable: genai.Ptr(true), Description: "YYYY-MM-DD"},
			"note":         {Type: genai.TypeString, Nullable: genai.Ptr(true)},
			"merchant":     {Type: genai.TypeString, Nullable: genai.Ptr(true)},
			"confidence": {
				Type:     genai.TypeObject,
				Required: []string{"type", "amount", "wallet", "category", "date"},
				Properties: map[string]*genai.Schema{
					"type": conf, "amount": conf, "wallet": conf, "category": conf, "date": conf,
				},
			},
		},
	}
}

// enum is a nullable string limited to values. With no values (for example
// a user without categories) it falls back to a plain nullable string.
func enum(values []string) *genai.Schema {
	s := &genai.Schema{Type: genai.TypeString, Nullable: genai.Ptr(true)}
	if len(values) > 0 {
		s.Format = "enum"
		s.Enum = values
	}

	return s
}
