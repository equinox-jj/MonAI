-- IANA name; decides "today" for transaction dates and the default month.
ALTER TABLE users ADD COLUMN timezone VARCHAR(64) NOT NULL DEFAULT 'Asia/Jakarta';
