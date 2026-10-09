package transaction

import "time"

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

// ToUploadURLResponse builds the presigned receipt upload response for a PUT URL.
func ToUploadURLResponse(uploadURL, objectKey, contentType string, expiresIn time.Duration) UploadURLResponse {
	return UploadURLResponse{
		UploadURL: uploadURL,
		Method:    "PUT",
		Headers:   map[string]string{"Content-Type": contentType},
		ObjectKey: objectKey,
		ExpiresIn: int(expiresIn.Seconds()),
	}
}
