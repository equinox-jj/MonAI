-- provider_aliases rows go with them via ON DELETE CASCADE; wallets.provider_id is set to NULL.
DELETE FROM payment_providers WHERE is_system AND slug IN (
    'cash',
    'bca',
    'mandiri',
    'bri',
    'bni',
    'bsi',
    'jago',
    'seabank',
    'gopay',
    'ovo',
    'dana',
    'shopeepay',
    'linkaja'
);
