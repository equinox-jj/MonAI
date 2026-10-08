-- The wallet and category FKs use NO ACTION (checked at end of statement), not RESTRICT,
-- so deleting a user cascades cleanly through wallets, categories and transactions.
CREATE TABLE transactions (
    id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    type         VARCHAR(10)  NOT NULL,
    amount       BIGINT       NOT NULL,
    wallet_id    UUID         NOT NULL REFERENCES wallets (id),
    to_wallet_id UUID         REFERENCES wallets (id),
    category_id  UUID         REFERENCES categories (id),
    date         DATE         NOT NULL,
    note         VARCHAR(200),
    merchant     VARCHAR(100),
    receipt_key  VARCHAR(255),
    source       VARCHAR(10)  NOT NULL DEFAULT 'MANUAL',
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    deleted_at   TIMESTAMPTZ,
    CONSTRAINT transactions_type_check CHECK (type IN ('EXPENSE', 'INCOME', 'TRANSFER')),
    CONSTRAINT transactions_amount_check CHECK (amount > 0 AND amount <= 999999999999),
    CONSTRAINT transactions_source_check CHECK (source IN ('MANUAL', 'QUICK_ADD', 'RECEIPT')),
    CONSTRAINT transactions_shape_check CHECK (
        (type = 'TRANSFER'
            AND to_wallet_id IS NOT NULL
            AND to_wallet_id <> wallet_id
            AND category_id IS NULL)
        OR
        (type IN ('EXPENSE', 'INCOME')
            AND to_wallet_id IS NULL
            AND category_id IS NOT NULL)
    )
);

-- List and cursor pagination.
CREATE INDEX transactions_user_date ON transactions (user_id, date DESC, id DESC) WHERE deleted_at IS NULL;
CREATE INDEX transactions_wallet_id_idx ON transactions (wallet_id);
CREATE INDEX transactions_to_wallet_id_idx ON transactions (to_wallet_id);
CREATE INDEX transactions_category_id_idx ON transactions (category_id);
