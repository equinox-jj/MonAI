import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/data/services/app_info_service.dart';
import 'package:monai/core/data/storage/app_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<AppThemeMode> themeMode();

  Future<void> setThemeMode(AppThemeMode mode);

  Future<AppLanguage> language();

  Future<void> setLanguage(AppLanguage language);

  Future<String> appVersion();
}

class SettingsLocalDataSourceImpl extends SettingsLocalDataSource
    with BaseLocalDataSource {
  SettingsLocalDataSourceImpl({
    required this._preferences,
    required this._appInfo,
  });

  final AppPreferences _preferences;
  final AppInfoService _appInfo;

  @override
  Future<AppThemeMode> themeMode() => safeCacheCall(_preferences.themeMode);

  @override
  Future<void> setThemeMode(AppThemeMode mode) =>
      safeCacheCall(() => _preferences.setThemeMode(mode));

  @override
  Future<AppLanguage> language() => safeCacheCall(_preferences.language);

  @override
  Future<void> setLanguage(AppLanguage language) =>
      safeCacheCall(() => _preferences.setLanguage(language));

  @override
  Future<String> appVersion() => safeCacheCall(_appInfo.version);
}
