CREATE TABLE payment_providers (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    slug       VARCHAR(50) NOT NULL,
    name       VARCHAR(50) NOT NULL,
    type       VARCHAR(10) NOT NULL,
    logo_key   VARCHAR(255),
    sort_order INT         NOT NULL DEFAULT 0,
    is_active  BOOLEAN     NOT NULL DEFAULT true,
    is_system  BOOLEAN     NOT NULL DEFAULT false,
    created_by UUID        REFERENCES users (id) ON DELETE SET NULL,
    updated_by UUID        REFERENCES users (id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    CONSTRAINT payment_providers_type_check CHECK (type IN ('CASH', 'BANK', 'E_WALLET', 'OTHER'))
);

-- A slug can be reused after its provider is soft-deleted.
CREATE UNIQUE INDEX payment_providers_slug_active ON payment_providers (slug) WHERE deleted_at IS NULL;
CREATE INDEX payment_providers_active_sort_idx ON payment_providers (is_active, sort_order) WHERE deleted_at IS NULL;

-- The PK guarantees an alias never points to two providers.
CREATE TABLE provider_aliases (
    alias       VARCHAR(50) PRIMARY KEY,
    provider_id UUID        NOT NULL REFERENCES payment_providers (id) ON DELETE CASCADE
);

CREATE INDEX provider_aliases_provider_id_idx ON provider_aliases (provider_id);

-- Bumped in the same transaction as every catalog change; backs the ETag of GET /payment-providers.
CREATE TABLE catalog_versions (
    name       VARCHAR(50) PRIMARY KEY,
    version    BIGINT      NOT NULL DEFAULT 1,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO catalog_versions (name) VALUES ('payment_providers');
