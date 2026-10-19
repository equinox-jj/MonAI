import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/storage/app_preferences.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';

class _MockAppPreferences extends Mock implements AppPreferences {}

void main() {
  late _MockAppPreferences preferences;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    preferences = _MockAppPreferences();
    dataSource = AuthLocalDataSourceImpl(preferences: preferences);
  });

  test('returns the stored onboarding flag', () async {
    // Arrange
    when(() => preferences.isOnboardingCompleted())
        .thenAnswer((_) async => true);

    // Act
    final result = await dataSource.isOnboardingCompleted();

    // Assert
    expect(result, isTrue);
  });

  test('saves the onboarding flag', () async {
    // Arrange
    when(() => preferences.setOnboardingCompleted()).thenAnswer((_) async {});

    // Act
    await dataSource.markOnboardingCompleted();

    // Assert
    verify(() => preferences.setOnboardingCompleted()).called(1);
  });

  test('a storage error becomes a CacheException', () async {
    // Arrange
    when(() => preferences.setOnboardingCompleted())
        .thenThrow(StateError('disk full'));

    // Act
    final call = dataSource.markOnboardingCompleted();

    // Assert
    await expectLater(call, throwsA(isA<CacheException>()));
  });
}
