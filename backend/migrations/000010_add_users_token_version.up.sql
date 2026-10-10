-- Copied into each access token as `ver`. Logout-all and password changes
-- increment it, which revokes every token issued before.
ALTER TABLE users ADD COLUMN token_version INT NOT NULL DEFAULT 0;
