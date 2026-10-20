import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/storage/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late SharedAppPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    preferences = SharedAppPreferences(prefs);
  });

  test('onboarding is not completed on a fresh install', () async {
    // Arrange
    // (empty preferences from setUp)

    // Act
    final result = await preferences.isOnboardingCompleted();

    // Assert
    expect(result, isFalse);
  });

  test('onboarding is completed after setting it', () async {
    // Arrange
    // (empty preferences from setUp)

    // Act
    await preferences.setOnboardingCompleted();

    // Assert
    expect(await preferences.isOnboardingCompleted(), isTrue);
  });

  test('reads a flag saved by an earlier launch', () async {
    // Arrange
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final relaunched = SharedAppPreferences(
      await SharedPreferences.getInstance(),
    );

    // Act
    final result = await relaunched.isOnboardingCompleted();

    // Assert
    expect(result, isTrue);
  });

  group('theme mode', () {
    test('follows the system until one is picked', () async {
      // Arrange
      // (empty preferences from setUp)

      // Act
      final result = await preferences.themeMode();

      // Assert
      expect(result, AppThemeMode.system);
    });

    test('reads back the picked theme', () async {
      // Arrange
      await preferences.setThemeMode(AppThemeMode.dark);

      // Act
      final result = await preferences.themeMode();

      // Assert
      expect(result, AppThemeMode.dark);
      expect(prefs.getString('theme_mode'), 'dark');
    });

    test('falls back to the system for an unknown stored value', () async {
      // Arrange
      await prefs.setString('theme_mode', 'sepia');

      // Act
      final result = await preferences.themeMode();

      // Assert
      expect(result, AppThemeMode.system);
    });
  });

  group('language', () {
    test('follows the system until one is picked', () async {
      // Arrange
      // (empty preferences from setUp)

      // Act
      final result = await preferences.language();

      // Assert
      expect(result, AppLanguage.system);
    });

    test('reads back the picked language', () async {
      // Arrange
      await preferences.setLanguage(AppLanguage.indonesian);

      // Act
      final result = await preferences.language();

      // Assert
      expect(result, AppLanguage.indonesian);
    });

    test('falls back to the system for an unknown stored value', () async {
      // Arrange
      await prefs.setString('language', 'klingon');

      // Act
      final result = await preferences.language();

      // Assert
      expect(result, AppLanguage.system);
    });
  });

  group('recent searches', () {
    test('are empty on a fresh install', () async {
      // Arrange
      // (empty preferences from setUp)

      // Act
      final result = await preferences.recentSearches();

      // Assert
      expect(result, isEmpty);
    });

    test('keep the newest first, without repeats, at most five', () async {
      // Arrange
      for (final query in ['kopi', 'gojek', 'Kopi', 'a', 'b', 'c', 'd']) {
        await preferences.addRecentSearch(query);
      }

      // Act
      final result = await preferences.recentSearches();

      // Assert
      expect(result, ['d', 'c', 'b', 'a', 'Kopi']);
    });

    test('ignore blank text', () async {
      // Arrange
      // (empty preferences from setUp)

      // Act
      await preferences.addRecentSearch('   ');

      // Assert
      expect(await preferences.recentSearches(), isEmpty);
    });
  });
}
