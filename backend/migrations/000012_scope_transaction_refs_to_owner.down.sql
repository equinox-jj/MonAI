ALTER TABLE transactions
    DROP CONSTRAINT transactions_wallet_owner_fkey,
    DROP CONSTRAINT transactions_to_wallet_owner_fkey,
    DROP CONSTRAINT transactions_category_owner_fkey,
    ADD CONSTRAINT transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES wallets (id),
    ADD CONSTRAINT transactions_to_wallet_id_fkey FOREIGN KEY (to_wallet_id) REFERENCES wallets (id),
    ADD CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories (id);

ALTER TABLE categories DROP CONSTRAINT categories_id_user_id_key;
ALTER TABLE wallets DROP CONSTRAINT wallets_id_user_id_key;
