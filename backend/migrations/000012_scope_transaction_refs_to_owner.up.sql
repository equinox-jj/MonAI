-- A transaction's wallets and category must belong to the transaction's user.
-- The service checks this too; the composite FKs make the database enforce it.
-- MATCH SIMPLE (the default) skips the check when to_wallet_id or category_id
-- is NULL. NO ACTION keeps the user-delete cascade working (see 000006).
ALTER TABLE wallets ADD CONSTRAINT wallets_id_user_id_key UNIQUE (id, user_id);
ALTER TABLE categories ADD CONSTRAINT categories_id_user_id_key UNIQUE (id, user_id);

ALTER TABLE transactions
    DROP CONSTRAINT transactions_wallet_id_fkey,
    DROP CONSTRAINT transactions_to_wallet_id_fkey,
    DROP CONSTRAINT transactions_category_id_fkey,
    ADD CONSTRAINT transactions_wallet_owner_fkey
        FOREIGN KEY (wallet_id, user_id) REFERENCES wallets (id, user_id),
    ADD CONSTRAINT transactions_to_wallet_owner_fkey
        FOREIGN KEY (to_wallet_id, user_id) REFERENCES wallets (id, user_id),
    ADD CONSTRAINT transactions_category_owner_fkey
        FOREIGN KEY (category_id, user_id) REFERENCES categories (id, user_id);
