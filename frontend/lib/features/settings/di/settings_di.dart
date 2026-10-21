import 'package:monai/core/app/injector.dart';
import 'package:monai/features/settings/data/datasources/admin_provider_remote_datasource.dart';
import 'package:monai/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:monai/features/settings/data/repository/admin_provider_repository_impl.dart';
import 'package:monai/features/settings/data/repository/settings_repository_impl.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';
import 'package:monai/features/settings/domain/usecase/create_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/delete_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_providers_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_app_version_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/provider_logo_uploader.dart';
import 'package:monai/features/settings/domain/usecase/refresh_settings_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_provider_active_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/update_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_provider_changes_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_settings_overview_usecase.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/bloc/manage_providers_bloc.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';
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
      )
      // Payment provider admin.
      ..registerLazySingleton<AdminProviderRemoteDataSource>(
        () => AdminProviderRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<AdminProviderRepository>(
        () => AdminProviderRepositoryImpl(remote: sl(), compressor: sl()),
      )
      // Shared by the list and the form, which don't share a scope.
      ..registerLazySingleton(
        ProviderChangeEvents.new,
        dispose: (events) => events.dispose(),
      )
      ..registerFactory(() => ProviderLogoUploader(sl()))
      ..registerFactory(() => GetAdminProvidersUseCase(sl()))
      ..registerFactory(() => GetAdminProviderUseCase(sl()))
      ..registerFactory(
        () => CreateProviderUseCase(
          repository: sl(),
          logoUploader: sl(),
          events: sl(),
        ),
      )
      ..registerFactory(
        () => UpdateProviderUseCase(
          repository: sl(),
          logoUploader: sl(),
          events: sl(),
        ),
      )
      ..registerFactory(
        () => SetProviderActiveUseCase(repository: sl(), events: sl()),
      )
      ..registerFactory(
        () => DeleteProviderUseCase(repository: sl(), events: sl()),
      )
      ..registerFactory(() => WatchProviderChangesUseCase(sl()))
      ..registerFactory(
        () => ManageProvidersBloc(
          watchUser: sl(),
          getProviders: sl(),
          watchChanges: sl(),
        ),
      )
      ..registerFactoryParam<ProviderFormBloc, String?, void>(
        (providerId, _) => ProviderFormBloc(
          providerId: providerId,
          watchUser: sl(),
          getProvider: sl(),
          create: sl(),
          update: sl(),
          setActive: sl(),
          delete: sl(),
          photos: sl(),
        ),
      );
  }
}
