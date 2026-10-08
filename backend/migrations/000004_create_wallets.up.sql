CREATE TABLE wallets (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    provider_id     UUID        REFERENCES payment_providers (id) ON DELETE SET NULL,
    name            VARCHAR(30) NOT NULL,
    type            VARCHAR(10) NOT NULL,
    initial_balance BIGINT      NOT NULL DEFAULT 0,
    icon            VARCHAR(50),
    color           VARCHAR(7),
    is_default      BOOLEAN     NOT NULL DEFAULT false,
    is_archived     BOOLEAN     NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT wallets_type_check CHECK (type IN ('CASH', 'BANK', 'E_WALLET', 'OTHER')),
    CONSTRAINT wallets_initial_balance_check CHECK (initial_balance >= 0),
    CONSTRAINT wallets_color_check CHECK (color IS NULL OR color ~ '^#[0-9A-Fa-f]{6}$'),
    CONSTRAINT wallets_default_not_archived CHECK (NOT (is_default AND is_archived))
);

CREATE UNIQUE INDEX wallets_user_name ON wallets (user_id, lower(name));
CREATE UNIQUE INDEX wallets_one_default ON wallets (user_id) WHERE is_default;
CREATE INDEX wallets_user_archived_idx ON wallets (user_id, is_archived);
CREATE INDEX wallets_provider_id_idx ON wallets (provider_id);
