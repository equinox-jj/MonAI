import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive device settings. None of them are cleared on sign out.
abstract interface class AppPreferences {
  Future<bool> isOnboardingCompleted();

  Future<void> setOnboardingCompleted();

  Future<AppThemeMode> themeMode();

  Future<void> setThemeMode(AppThemeMode mode);

  Future<AppLanguage> language();

  Future<void> setLanguage(AppLanguage language);

  Future<List<String>> recentSearches();

  Future<void> addRecentSearch(String query);

  Future<String?> csvDelimiter();

  Future<void> setCsvDelimiter(String name);
}

class SharedAppPreferences implements AppPreferences {
  const SharedAppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingCompleted = 'onboarding_completed';
  static const _kThemeMode = 'theme_mode';
  static const _kLanguage = 'language';
  static const _kRecentSearches = 'recent_searches';
  static const _kCsvDelimiter = 'csv_delimiter';
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

  @override
  Future<String?> csvDelimiter() async => _prefs.getString(_kCsvDelimiter);

  @override
  Future<void> setCsvDelimiter(String name) async {
    await _prefs.setString(_kCsvDelimiter, name);
  }
}
