import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Small, non-sensitive app settings kept on the device. Every
/// [SharedPreferences] key lives behind this abstraction. None of them are
/// cleared on sign out.
abstract interface class AppPreferences {
  /// Whether onboarding was finished on this device.
  Future<bool> isOnboardingCompleted();

  /// Remembers that onboarding was finished.
  Future<void> setOnboardingCompleted();

  /// The picked theme; [AppThemeMode.system] until one is picked.
  Future<AppThemeMode> themeMode();

  /// Remembers the picked theme.
  Future<void> setThemeMode(AppThemeMode mode);

  /// The picked language; [AppLanguage.system] until one is picked.
  Future<AppLanguage> language();

  /// Remembers the picked language.
  Future<void> setLanguage(AppLanguage language);
}

/// [AppPreferences] backed by [SharedPreferences].
class SharedAppPreferences implements AppPreferences {
  const SharedAppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingCompleted = 'onboarding_completed';
  static const _kThemeMode = 'theme_mode';
  static const _kLanguage = 'language';

  @override
  Future<bool> isOnboardingCompleted() async =>
      _prefs.getBool(_kOnboardingCompleted) ?? false;

  @override
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_kOnboardingCompleted, true);
  }

  // Stored by name; an unknown value (e.g. from a newer build) falls back to
  // the default.
  @override
  Future<AppThemeMode> themeMode() async =>
      AppThemeMode.values.asNameMap()[_prefs.getString(_kThemeMode)] ??
      AppThemeMode.system;

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_kThemeMode, mode.name);
  }

  @override
  Future<AppLanguage> language() async =>
      AppLanguage.values.asNameMap()[_prefs.getString(_kLanguage)] ??
      AppLanguage.system;

  @override
  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setString(_kLanguage, language.name);
  }
}
