import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/domain/logic/settings_rules.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

import '../../../../helpers/entity_fixtures.dart';

User _admin({Set<String> permissions = const {'payment_provider.update'}}) =>
    user(name: 'Joshua Pardede').copyWith(
      role: const UserRole(slug: 'admin', name: 'Admin'),
      permissions: permissions,
      avatarUrl: 'https://cdn.monai.id/a.jpg',
    );

void main() {
  group('buildSettingsOverview', () {
    test('summarizes the cached sections', () {
      // Arrange
      final cached = _admin();

      // Act
      final overview = buildSettingsOverview(
        user: cached,
        budget: budget(),
        categories: [
          category(),
          category(id: 'c2'),
        ],
        wallets: [wallet()],
      );

      // Assert
      expect(
        overview,
        const SettingsOverview(
          profile: SettingsProfile(
            name: 'Joshua Pardede',
            email: 'ana@monai.id',
            initials: 'JP',
            avatarUrl: 'https://cdn.monai.id/a.jpg',
            roleBadge: 'Admin',
          ),
          budgetLimit: 1000000,
          categoryCount: 2,
          walletCount: 1,
          canManageProviders: true,
        ),
      );
    });

    test('leaves empty values before anything is cached', () {
      // Arrange
      // (nothing cached)

      // Act
      final overview = buildSettingsOverview(
        user: null,
        budget: null,
        categories: const [],
        wallets: const [],
      );

      // Assert
      expect(overview, const SettingsOverview());
    });
  });

  test('a regular user gets no role badge', () {
    // Arrange
    final regular = user();

    // Act
    final profile = settingsProfileOf(regular);

    // Assert
    expect(profile.roleBadge, isNull);
  });

  group('canManageProviders', () {
    for (final permission in kProviderManagePermissions) {
      test('is true with $permission', () {
        // Arrange
        final admin = _admin(permissions: {permission});

        // Act
        final canManage = canManageProviders(admin);

        // Assert
        expect(canManage, isTrue);
      });
    }

    test('is false with read access only, or no user', () {
      // Arrange
      final reader = _admin(permissions: {'payment_provider.read'});

      // Act
      final results = [canManageProviders(reader), canManageProviders(null)];

      // Assert
      expect(results, [false, false]);
    });
  });

  test('a sign-out fails as network when offline or timed out', () {
    // Arrange
    const failures = <Failure>[
      Failure.network(),
      Failure.timeout(),
      Failure.server(500),
    ];

    // Act
    final reasons = failures.map(signOutFailureOf).toList();

    // Assert
    expect(reasons, [
      SettingsSignOutFailure.network,
      SettingsSignOutFailure.network,
      SettingsSignOutFailure.unexpected,
    ]);
  });

  test('any app language but Indonesian is shown as English', () {
    // Arrange
    const codes = ['id', 'en', 'fr'];

    // Act
    final shown = codes.map(shownLanguage).toList();

    // Assert
    expect(shown, [
      AppLanguage.indonesian,
      AppLanguage.english,
      AppLanguage.english,
    ]);
  });
}
