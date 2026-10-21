import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:monai/features/settings/data/repository/settings_repository_impl.dart';

class _MockLocal extends Mock implements SettingsLocalDataSource {}

void main() {
  late _MockLocal local;
  late SettingsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(AppThemeMode.system);
    registerFallbackValue(AppLanguage.system);
  });

  setUp(() {
    local = _MockLocal();
    repository = SettingsRepositoryImpl(local: local);
  });

  test('reads and saves the theme', () async {
    // Arrange
    when(() => local.themeMode()).thenAnswer((_) async => AppThemeMode.dark);
    when(() => local.setThemeMode(any())).thenAnswer((_) async {});

    // Act
    final read = await repository.themeMode();
    final saved = await repository.setThemeMode(AppThemeMode.light);

    // Assert
    expect(read, const Right<Failure, AppThemeMode>(AppThemeMode.dark));
    expect(saved, const Right<Failure, AppThemeMode>(AppThemeMode.light));
    verify(() => local.setThemeMode(AppThemeMode.light)).called(1);
  });

  test('reads and saves the language', () async {
    // Arrange
    when(() => local.language()).thenAnswer((_) async => AppLanguage.english);
    when(() => local.setLanguage(any())).thenAnswer((_) async {});

    // Act
    final read = await repository.language();
    final saved = await repository.setLanguage(AppLanguage.indonesian);

    // Assert
    expect(read, const Right<Failure, AppLanguage>(AppLanguage.english));
    expect(saved, const Right<Failure, AppLanguage>(AppLanguage.indonesian));
    verify(() => local.setLanguage(AppLanguage.indonesian)).called(1);
  });

  test('a storage error becomes a CacheFailure', () async {
    // Arrange
    when(() => local.setThemeMode(any()))
        .thenThrow(const CacheException(message: 'boom'));

    // Act
    final result = await repository.setThemeMode(AppThemeMode.dark);

    // Assert
    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('reads the app version', () async {
    // Arrange
    when(() => local.appVersion()).thenAnswer((_) async => '1.0.0');

    // Act
    final result = await repository.appVersion();

    // Assert
    expect(result, const Right<Failure, String>('1.0.0'));
  });
}
