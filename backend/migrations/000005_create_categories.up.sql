CREATE TABLE categories (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    name       VARCHAR(30) NOT NULL,
    type       VARCHAR(10) NOT NULL,
    icon       VARCHAR(50),
    color      VARCHAR(7),
    is_default BOOLEAN     NOT NULL DEFAULT false,
    is_system  BOOLEAN     NOT NULL DEFAULT false,
    is_hidden  BOOLEAN     NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT categories_type_check CHECK (type IN ('EXPENSE', 'INCOME')),
    CONSTRAINT categories_color_check CHECK (color IS NULL OR color ~ '^#[0-9A-Fa-f]{6}$'),
    CONSTRAINT categories_system_not_hidden CHECK (NOT (is_system AND is_hidden))
);

CREATE UNIQUE INDEX categories_user_type_name ON categories (user_id, type, lower(name));
CREATE INDEX categories_user_type_idx ON categories (user_id, type);
