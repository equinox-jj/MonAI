import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/local_cache.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/data/storage/app_preferences.dart';
import 'package:monai/core/data/storage/token_storage.dart';

abstract class AuthLocalDataSource {
  Future<bool> isOnboardingCompleted();

  Future<void> markOnboardingCompleted();

  Future<void> startSession(String accessToken);

  Future<void> clearCache();

  /// True when a token is stored, which also marks the session signed in.
  Future<bool> restoreSession();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource
    with BaseLocalDataSource {
  AuthLocalDataSourceImpl({
    required this._preferences,
    required this._tokenStorage,
    required this._localCache,
    required this._sessionManager,
  });

  final AppPreferences _preferences;
  final TokenStorage _tokenStorage;
  final LocalCache _localCache;
  final SessionManager _sessionManager;

  @override
  Future<bool> isOnboardingCompleted() =>
      safeCacheCall(_preferences.isOnboardingCompleted);

  @override
  Future<void> markOnboardingCompleted() =>
      safeCacheCall(_preferences.setOnboardingCompleted);

  @override
  Future<void> startSession(String accessToken) => safeCacheCall(() async {
    await _tokenStorage.saveAccessToken(accessToken);
    _sessionManager.signedIn();
  });

  @override
  Future<void> clearCache() => safeCacheCall(_localCache.clear);

  @override
  Future<bool> restoreSession() => safeCacheCall(() async {
    final token = await _tokenStorage.readAccessToken();
    final signedIn = token != null && token.isNotEmpty;
    if (signedIn) _sessionManager.signedIn();
    return signedIn;
  });
}
