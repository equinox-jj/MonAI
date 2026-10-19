import 'package:shared_preferences/shared_preferences.dart';

/// Small, non-sensitive app settings kept on the device. Every
/// [SharedPreferences] key lives behind this abstraction.
abstract interface class AppPreferences {
  /// Whether onboarding was finished on this device.
  Future<bool> isOnboardingCompleted();

  /// Remembers that onboarding was finished.
  Future<void> setOnboardingCompleted();
}

/// [AppPreferences] backed by [SharedPreferences].
class SharedAppPreferences implements AppPreferences {
  const SharedAppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingCompleted = 'onboarding_completed';

  @override
  Future<bool> isOnboardingCompleted() async =>
      _prefs.getBool(_kOnboardingCompleted) ?? false;

  @override
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_kOnboardingCompleted, true);
  }
}
