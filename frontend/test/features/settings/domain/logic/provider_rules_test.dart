import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';

import '../../../../helpers/entity_fixtures.dart';

void main() {
  group('providerMatches', () {
    test('matches the name, slug or an alias, ignoring case', () {
      // Arrange
      final provider = adminProvider(aliases: ['gpay']);

      // Act
      final matches = [
        'GOP',
        'gopay',
        'GPA',
        '  ',
      ].map((q) => providerMatches(provider, q));

      // Assert
      expect(matches, everyElement(isTrue));
    });

    test('does not match anything else', () {
      // Arrange
      final provider = adminProvider();

      // Act
      final matches = providerMatches(provider, 'ovo');

      // Assert
      expect(matches, isFalse);
    });
  });

  test('a system provider shows as System whatever its status', () {
    // Arrange
    final provider = adminProvider(isSystem: true, isActive: false);

    // Act
    final status = providerStatusOf(provider);

    // Assert
    expect(status, ProviderStatus.system);
  });

  test('an inactive provider shows as Inactive', () {
    // Arrange
    final provider = adminProvider(isActive: false);

    // Act
    final status = providerStatusOf(provider);

    // Assert
    expect(status, ProviderStatus.inactive);
  });

  group('permissions', () {
    test('editing needs the update or delete permission', () {
      // Arrange
      final deleter = userWith({kProviderDeletePermission});
      final creator = userWith({kProviderCreatePermission});

      // Act
      final canEdit = (canEditProviders(deleter), canEditProviders(creator));

      // Assert
      expect(canEdit, (true, false));
    });

    test('saving needs create for a new provider, update otherwise', () {
      // Arrange
      final creator = userWith({kProviderCreatePermission});

      // Act
      final canSave = (
        canSaveProvider(creator, isNew: true),
        canSaveProvider(creator, isNew: false),
      );

      // Assert
      expect(canSave, (true, false));
    });

    test('a system provider can never be deleted', () {
      // Arrange
      final admin = userWith({kProviderDeletePermission});

      // Act
      final canDelete = (
        canDeleteProvider(admin, adminProvider()),
        canDeleteProvider(admin, adminProvider(isSystem: true)),
        canDeleteProvider(admin, null),
      );

      // Assert
      expect(canDelete, (true, false, false));
    });
  });

  test('typed aliases split on commas, normalized, without repeats', () {
    // Arrange
    const aliases = ['gopay'];

    // Act
    final updated = withTypedAliases(aliases, ' GPay, gopay,, go pay ');

    // Assert
    expect(updated, ['gopay', 'gpay', 'go pay']);
  });

  test('the slug preview is the saved slug once there is one', () {
    // Arrange
    final saved = adminProvider(name: 'GoPay');

    // Act
    final previews = (
      providerSlugPreview(saved, 'Renamed'),
      providerSlugPreview(null, 'Link Aja'),
    );

    // Assert
    expect(previews, ('gopay', 'link-aja'));
  });

  test('the sort order input takes an optional minus and digits', () {
    // Arrange
    const inputs = ['', '-', '-12', '100', '1a', '1234567890'];

    // Act
    final accepted = inputs.map(kSortOrderInput.hasMatch).toList();

    // Assert
    expect(accepted, [true, true, true, true, false, false]);
  });
}
