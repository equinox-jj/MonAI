-- role_permissions rows go with them via ON DELETE CASCADE.
-- Fails while any user still references these roles (users.role_id is ON DELETE RESTRICT).
DELETE FROM permissions WHERE code IN (
    'payment_provider.view',
    'payment_provider.create',
    'payment_provider.update',
    'payment_provider.delete'
);

DELETE FROM roles WHERE slug IN ('user', 'admin');
