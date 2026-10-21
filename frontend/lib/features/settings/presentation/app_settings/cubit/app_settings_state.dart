part of 'app_settings_cubit.dart';

@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppLanguage.system) AppLanguage language,
  }) = _AppSettingsState;
}
