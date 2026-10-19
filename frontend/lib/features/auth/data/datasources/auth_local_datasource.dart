import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/local_cache.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/storage/app_preferences.dart';
import 'package:monai/core/storage/token_storage.dart';

abstract class AuthLocalDataSource {
  /// Whether onboarding was finished on this device.
  Future<bool> isOnboardingCompleted();

  /// Remembers that onboarding was finished, so it shows only once.
  Future<void> markOnboardingCompleted();

  /// Stores [accessToken] and marks the session signed in.
  Future<void> startSession(String accessToken);

  /// Removes the token, clears the cache and marks the session signed out.
  /// Only a token that fails to clear throws: once it is gone the user is
  /// signed out, and the next sign-in clears a cache left behind.
  Future<void> endSession();

  /// Deletes every cached row, e.g. a previous account's data.
  Future<void> clearCache();

  /// Marks the session signed in when a token is stored; returns whether one
  /// is.
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
  Future<void> endSession() => safeCacheCall(() async {
    await _tokenStorage.clear();
    try {
      await _localCache.clear();
    } on Object catch (_) {}
    _sessionManager.signedOut();
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
