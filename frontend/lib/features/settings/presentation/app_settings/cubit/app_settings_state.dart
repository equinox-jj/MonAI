part of 'app_settings_cubit.dart';

@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    /// The picked theme; [AppThemeMode.system] follows the device.
    @Default(AppThemeMode.system) AppThemeMode themeMode,

    /// The picked language; [AppLanguage.system] follows the device.
    @Default(AppLanguage.system) AppLanguage language,
  }) = _AppSettingsState;
}
