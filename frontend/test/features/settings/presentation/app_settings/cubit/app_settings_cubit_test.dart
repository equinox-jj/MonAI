import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';

import '../../../../../helpers/settings_fakes.dart';

void main() {
  late SettingsFakes fakes;
  late AppSettingsCubit cubit;

  setUp(() {
    fakes = SettingsFakes();
    cubit = fakes.appSettings;
  });

  tearDown(() => cubit.close());

  test('loads the saved theme and language', () async {
    // Arrange
    when(() => fakes.getThemeMode(any()))
        .thenAnswer((_) async => const Right(AppThemeMode.dark));
    when(() => fakes.getLanguage(any()))
        .thenAnswer((_) async => const Right(AppLanguage.indonesian));

    // Act
    await cubit.load();

    // Assert
    expect(
      cubit.state,
      const AppSettingsState(
        themeMode: AppThemeMode.dark,
        language: AppLanguage.indonesian,
      ),
    );
  });

  test('follows the device when the saved picks cannot be read', () async {
    // Arrange
    when(() => fakes.getThemeMode(any()))
        .thenAnswer((_) async => const Left(Failure.cache()));
    when(() => fakes.getLanguage(any()))
        .thenAnswer((_) async => const Left(Failure.cache()));

    // Act
    await cubit.load();

    // Assert
    expect(cubit.state, const AppSettingsState());
  });

  test('a pick switches at once and is saved', () async {
    // Arrange
    final states = <AppSettingsState>[];
    final subscription = cubit.stream.listen(states.add);

    // Act
    await cubit.themeModePicked(AppThemeMode.dark);
    await cubit.languagePicked(AppLanguage.english);
    await subscription.cancel();

    // Assert
    expect(states, const [
      AppSettingsState(themeMode: AppThemeMode.dark),
      AppSettingsState(
        themeMode: AppThemeMode.dark,
        language: AppLanguage.english,
      ),
    ]);
    verify(() => fakes.setThemeMode(AppThemeMode.dark)).called(1);
    verify(() => fakes.setLanguage(AppLanguage.english)).called(1);
  });

  test('picking the current value saves nothing', () async {
    // Arrange
    // (the state starts at system)

    // Act
    await cubit.themeModePicked(AppThemeMode.system);
    await cubit.languagePicked(AppLanguage.system);

    // Assert
    verifyNever(() => fakes.setThemeMode(any()));
    verifyNever(() => fakes.setLanguage(any()));
    verifyNever(() => fakes.getThemeMode(const NoParams()));
  });
}
