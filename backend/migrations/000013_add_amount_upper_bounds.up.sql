-- Caps keep balance sums and budget math far from BIGINT overflow.
ALTER TABLE wallets ADD CONSTRAINT wallets_initial_balance_max CHECK (initial_balance <= 999999999999999);
ALTER TABLE budgets ADD CONSTRAINT budgets_limit_amount_max CHECK (limit_amount <= 999999999999999);
