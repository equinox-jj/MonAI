-- Default categories were seeded without an icon or color, so charts drew them
-- all in the fallback gray. Fill in what the user hasn't set themselves.
UPDATE categories c
SET icon  = COALESCE(c.icon, d.icon),
    color = COALESCE(c.color, d.color)
FROM (VALUES
    ('Food',          'EXPENSE', 'restaurant',     '#F97316'),
    ('Transport',     'EXPENSE', 'directions_car', '#0EA5E9'),
    ('Bills',         'EXPENSE', 'receipt_long',   '#8B5CF6'),
    ('Shopping',      'EXPENSE', 'shopping_bag',   '#EC4899'),
    ('Health',        'EXPENSE', 'favorite',       '#10B981'),
    ('Entertainment', 'EXPENSE', 'movie',          '#F59E0B'),
    ('Other',         'EXPENSE', 'inventory_2',    '#64748B'),
    ('Salary',        'INCOME',  'payments',       '#14B8A6'),
    ('Bonus',         'INCOME',  'redeem',         '#84CC16'),
    ('Other Income',  'INCOME',  'savings',        '#6366F1')
) AS d(name, type, icon, color)
WHERE c.is_default
  AND c.name = d.name
  AND c.type = d.type
  AND (c.icon IS NULL OR c.color IS NULL);
