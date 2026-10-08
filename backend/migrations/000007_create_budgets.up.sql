CREATE TABLE budgets (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    month        CHAR(7)     NOT NULL,
    limit_amount BIGINT      NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT budgets_month_check CHECK (month ~ '^[0-9]{4}-(0[1-9]|1[0-2])$'),
    CONSTRAINT budgets_limit_amount_check CHECK (limit_amount > 0),
    CONSTRAINT budgets_user_month_key UNIQUE (user_id, month)
);
