import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';
import 'package:monai/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_theme_mode_usecase.dart';

class _MockRepository extends Mock implements SettingsRepository {}

// The settings use cases only forward to the repository.
void main() {
  late _MockRepository repository;

  setUp(() => repository = _MockRepository());

  test('the theme is read and saved', () async {
    // Arrange
    when(() => repository.themeMode())
        .thenAnswer((_) async => const Right(AppThemeMode.dark));
    when(() => repository.setThemeMode(AppThemeMode.light))
        .thenAnswer((_) async => const Right(AppThemeMode.light));

    // Act
    final read = await GetThemeModeUseCase(repository)(const NoParams());
    final saved = await SetThemeModeUseCase(repository)(AppThemeMode.light);

    // Assert
    expect(read, const Right<Failure, AppThemeMode>(AppThemeMode.dark));
    expect(saved, const Right<Failure, AppThemeMode>(AppThemeMode.light));
  });

  test('the language is read and saved', () async {
    // Arrange
    when(() => repository.language())
        .thenAnswer((_) async => const Right(AppLanguage.english));
    when(() => repository.setLanguage(AppLanguage.indonesian))
        .thenAnswer((_) async => const Right(AppLanguage.indonesian));

    // Act
    final read = await GetLanguageUseCase(repository)(const NoParams());
    final saved = await SetLanguageUseCase(repository)(AppLanguage.indonesian);

    // Assert
    expect(read, const Right<Failure, AppLanguage>(AppLanguage.english));
    expect(saved, const Right<Failure, AppLanguage>(AppLanguage.indonesian));
  });
}
