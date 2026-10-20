import 'package:monai/core/di/injector.dart';
import 'package:monai/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:monai/features/settings/data/repository/settings_repository_impl.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';
import 'package:monai/features/settings/domain/usecase/get_app_version_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/refresh_settings_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_settings_overview_usecase.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';
import 'package:monai/features/settings/presentation/pages/settings/bloc/settings_bloc.dart';

class SettingsDI {
  SettingsDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<SettingsLocalDataSource>(
        () => SettingsLocalDataSourceImpl(preferences: sl(), appInfo: sl()),
      )
      ..registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(local: sl()),
      )
      ..registerFactory(() => GetThemeModeUseCase(sl()))
      ..registerFactory(() => SetThemeModeUseCase(sl()))
      ..registerFactory(() => GetLanguageUseCase(sl()))
      ..registerFactory(() => SetLanguageUseCase(sl()))
      ..registerFactory(() => GetAppVersionUseCase(sl()))
      ..registerFactory(
        () => WatchSettingsOverviewUseCase(
          user: sl(),
          budget: sl(),
          categories: sl(),
          wallets: sl(),
        ),
      )
      ..registerFactory(
        () =>
            RefreshSettingsUseCase(user: sl(), budget: sl(), categories: sl()),
      )
      // Lives as long as the app: MyApp draws the theme and language from it.
      ..registerLazySingleton(
        () => AppSettingsCubit(
          getThemeMode: sl(),
          setThemeMode: sl(),
          getLanguage: sl(),
          setLanguage: sl(),
        ),
        dispose: (cubit) => cubit.close(),
      )
      ..registerFactory(
        () => SettingsBloc(
          watchOverview: sl(),
          refresh: sl(),
          getAppVersion: sl(),
          logout: sl(),
          logoutAllDevices: sl(),
        ),
      );
  }
}
