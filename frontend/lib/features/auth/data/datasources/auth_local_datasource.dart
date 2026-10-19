import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/storage/app_preferences.dart';

abstract class AuthLocalDataSource {
  /// Whether onboarding was finished on this device.
  Future<bool> isOnboardingCompleted();

  /// Remembers that onboarding was finished, so it shows only once.
  Future<void> markOnboardingCompleted();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource
    with BaseLocalDataSource {
  AuthLocalDataSourceImpl({required this._preferences});

  final AppPreferences _preferences;

  @override
  Future<bool> isOnboardingCompleted() =>
      safeCacheCall(_preferences.isOnboardingCompleted);

  @override
  Future<void> markOnboardingCompleted() =>
      safeCacheCall(_preferences.setOnboardingCompleted);
}
