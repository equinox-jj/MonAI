-- Codes and slugs must match the constants in internal/rbac/model.go.
INSERT INTO roles (slug, name, description, is_system, is_default) VALUES
    ('user',  'User',  'Default role assigned on register.', true, true),
    ('admin', 'Admin', 'Manages the payment provider catalog.', true, false)
ON CONFLICT (slug) DO NOTHING;

INSERT INTO permissions (code, description) VALUES
    ('payment_provider.view',   'List and view payment providers.'),
    ('payment_provider.create', 'Create payment providers.'),
    ('payment_provider.update', 'Update payment providers.'),
    ('payment_provider.delete', 'Delete payment providers.')
ON CONFLICT (code) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON
    (r.slug = 'admin' AND p.code LIKE 'payment_provider.%')
    OR (r.slug = 'user' AND p.code = 'payment_provider.view')
ON CONFLICT DO NOTHING;
