-- System providers; admins manage the rest through the API. Logos are uploaded later.
INSERT INTO payment_providers (slug, name, type, sort_order, is_system) VALUES
    ('cash',      'Cash',         'CASH',     0,   true),
    ('bca',       'BCA',          'BANK',     10,  true),
    ('mandiri',   'Bank Mandiri', 'BANK',     20,  true),
    ('bri',       'BRI',          'BANK',     30,  true),
    ('bni',       'BNI',          'BANK',     40,  true),
    ('bsi',       'BSI',          'BANK',     50,  true),
    ('jago',      'Bank Jago',    'BANK',     60,  true),
    ('seabank',   'SeaBank',      'BANK',     70,  true),
    ('gopay',     'GoPay',        'E_WALLET', 100, true),
    ('ovo',       'OVO',          'E_WALLET', 110, true),
    ('dana',      'DANA',         'E_WALLET', 120, true),
    ('shopeepay', 'ShopeePay',    'E_WALLET', 130, true),
    ('linkaja',   'LinkAja',      'E_WALLET', 140, true)
ON CONFLICT DO NOTHING;

-- Aliases are stored lowercase and are globally unique (PK).
INSERT INTO provider_aliases (alias, provider_id)
SELECT a.alias, p.id
FROM (VALUES
    ('tunai',             'cash'),
    ('bank central asia', 'bca'),
    ('livin',             'mandiri'),
    ('brimo',             'bri'),
    ('bank syariah indonesia', 'bsi'),
    ('gpay',              'gopay'),
    ('go-pay',            'gopay'),
    ('spay',              'shopeepay'),
    ('shopee pay',        'shopeepay')
) AS a (alias, slug)
JOIN payment_providers p ON p.slug = a.slug AND p.deleted_at IS NULL
ON CONFLICT (alias) DO NOTHING;
