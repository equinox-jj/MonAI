package transaction

// ToTransactionResponse maps a transaction to the API shape. receiptURL is
// the presigned GET URL for t.ReceiptKey (nil when there is no receipt).
func ToTransactionResponse(t *Transaction, receiptURL *string) TransactionResponse {
	return TransactionResponse{
		ID:         t.ID,
		Type:       t.Type,
		Amount:     t.Amount,
		WalletID:   t.WalletID,
		ToWalletID: t.ToWalletID,
		CategoryID: t.CategoryID,
		Date:       t.Date.Format(dateLayout),
		Note:       t.Note,
		Merchant:   t.Merchant,
		ReceiptURL: receiptURL,
		Source:     t.Source,
		CreatedAt:  t.CreatedAt.UTC(),
		UpdatedAt:  t.UpdatedAt.UTC(),
	}
}
