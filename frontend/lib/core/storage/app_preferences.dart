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

  /// The last transaction searches, newest first.
  Future<List<String>> recentSearches();

  /// Puts [query] first in [recentSearches], dropping an older copy of it and
  /// the oldest past the limit. Blank text is ignored.
  Future<void> addRecentSearch(String query);
}

/// [AppPreferences] backed by [SharedPreferences].
class SharedAppPreferences implements AppPreferences {
  const SharedAppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingCompleted = 'onboarding_completed';
  static const _kThemeMode = 'theme_mode';
  static const _kLanguage = 'language';
  static const _kRecentSearches = 'recent_searches';

  /// How many searches [recentSearches] keeps.
  static const recentSearchLimit = 5;

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

  @override
  Future<List<String>> recentSearches() async =>
      _prefs.getStringList(_kRecentSearches) ?? const [];

  // A repeat is matched ignoring case, and keeps the casing typed last.
  @override
  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final key = trimmed.toLowerCase();
    final searches = [
      trimmed,
      ...(await recentSearches()).where((s) => s.toLowerCase() != key),
    ].take(recentSearchLimit).toList();
    await _prefs.setStringList(_kRecentSearches, searches);
  }
}
