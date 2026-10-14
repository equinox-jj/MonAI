-- Lets the receipt cleanup job find old deleted receipts and check whether
-- another transaction still uses a key without scanning the table.
CREATE INDEX transactions_deleted_receipt_idx ON transactions (deleted_at)
    WHERE deleted_at IS NOT NULL AND receipt_key IS NOT NULL;
CREATE INDEX transactions_receipt_key_idx ON transactions (receipt_key)
    WHERE receipt_key IS NOT NULL;
