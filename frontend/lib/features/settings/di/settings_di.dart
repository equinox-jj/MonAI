import 'package:monai/core/di/injector.dart';
import 'package:monai/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:monai/features/settings/data/repository/settings_repository_impl.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';
import 'package:monai/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_theme_mode_usecase.dart';

class SettingsDI {
  SettingsDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<SettingsLocalDataSource>(
        () => SettingsLocalDataSourceImpl(preferences: sl()),
      )
      ..registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(local: sl()),
      )
      ..registerFactory(() => GetThemeModeUseCase(sl()))
      ..registerFactory(() => SetThemeModeUseCase(sl()))
      ..registerFactory(() => GetLanguageUseCase(sl()))
      ..registerFactory(() => SetLanguageUseCase(sl()));
  }
}
