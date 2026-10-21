import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/domain/usecase/get_app_version_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/refresh_settings_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_settings_overview_usecase.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';
import 'package:monai/features/settings/presentation/pages/settings/bloc/settings_bloc.dart';
import 'package:monai/features/shared/domain/usecase/logout_all_devices_usecase.dart';
import 'package:monai/features/shared/domain/usecase/logout_usecase.dart';

class MockWatchSettingsOverview extends Mock
    implements WatchSettingsOverviewUseCase {}

class MockRefreshSettings extends Mock implements RefreshSettingsUseCase {}

class MockGetAppVersion extends Mock implements GetAppVersionUseCase {}

class MockLogout extends Mock implements LogoutUseCase {}

class MockLogoutAllDevices extends Mock implements LogoutAllDevicesUseCase {}

class MockGetThemeMode extends Mock implements GetThemeModeUseCase {}

class MockSetThemeMode extends Mock implements SetThemeModeUseCase {}

class MockGetLanguage extends Mock implements GetLanguageUseCase {}

class MockSetLanguage extends Mock implements SetLanguageUseCase {}

/// A cached overview for a regular user: no badge, no admin section.
const cachedOverview = SettingsOverview(
  profile: SettingsProfile(name: 'Ana', email: 'ana@monai.id', initials: 'A'),
  categoryCount: 10,
  walletCount: 2,
);

/// Mocked use cases behind a real [SettingsBloc] and [AppSettingsCubit], for
/// widget tests that reach the Settings tab. By default the cache holds
/// [cachedOverview], the version is `1.0.0`, and saves and sign-outs succeed.
class SettingsFakes {
  SettingsFakes({SettingsOverview overview = cachedOverview}) {
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(const NoParams());
    registerFallbackValue(AppThemeMode.system);
    registerFallbackValue(AppLanguage.system);
    cacheHolds(overview);
    when(() => refresh(any())).thenAnswer((_) async => const Right(unit));
    when(() => appVersion(any())).thenAnswer((_) async => const Right('1.0.0'));
    when(() => logout(any()))
        .thenAnswer((_) async => const Right(SessionStatus.signedOut));
    when(() => logoutAllDevices(any()))
        .thenAnswer((_) async => const Right(SessionStatus.signedOut));
    when(() => setThemeMode(any())).thenAnswer(
      (i) async => Right(i.positionalArguments.single as AppThemeMode),
    );
    when(() => setLanguage(any())).thenAnswer(
      (i) async => Right(i.positionalArguments.single as AppLanguage),
    );
  }

  final watch = MockWatchSettingsOverview();
  final refresh = MockRefreshSettings();
  final appVersion = MockGetAppVersion();
  final logout = MockLogout();
  final logoutAllDevices = MockLogoutAllDevices();
  final getThemeMode = MockGetThemeMode();
  final setThemeMode = MockSetThemeMode();
  final getLanguage = MockGetLanguage();
  final setLanguage = MockSetLanguage();

  /// The app-wide theme and language; close it in a tear-down.
  late final appSettings = AppSettingsCubit(
    getThemeMode: getThemeMode,
    setThemeMode: setThemeMode,
    getLanguage: getLanguage,
    setLanguage: setLanguage,
  );

  /// Makes the cache hold [overview].
  void cacheHolds(SettingsOverview overview) => when(
    () => watch(any()),
  ).thenAnswer((_) => Stream.value(Right<Failure, SettingsOverview>(overview)));

  /// Registers a [SettingsBloc] factory on `sl`, as `SettingsPage` reads it.
  void register() => sl.registerFactory(
    () => SettingsBloc(
      watchOverview: watch,
      refresh: refresh,
      getAppVersion: appVersion,
      logout: logout,
      logoutAllDevices: logoutAllDevices,
      now: () => DateTime(2026, 10, 20),
    ),
  );
}
