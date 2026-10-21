import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/local_cache.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/storage/token_storage.dart';

abstract class SessionLocalDataSource {
  /// Removes the token, clears the cache and marks the session signed out.
  /// Only a token that fails to clear throws: once it is gone the user is
  /// signed out, and the next sign-in clears a cache left behind.
  Future<void> endSession();

  /// Ends the session like [endSession], after a password change: the app
  /// shows the password-changed dialog instead of going straight to Sign in.
  Future<void> endSessionAfterPasswordChange();
}

class SessionLocalDataSourceImpl extends SessionLocalDataSource
    with BaseLocalDataSource {
  SessionLocalDataSourceImpl({
    required this._tokenStorage,
    required this._localCache,
    required this._sessionManager,
  });

  final TokenStorage _tokenStorage;
  final LocalCache _localCache;
  final SessionManager _sessionManager;

  @override
  Future<void> endSession() => safeCacheCall(() async {
    await _clear();
    _sessionManager.signedOut();
  });

  @override
  Future<void> endSessionAfterPasswordChange() => safeCacheCall(() async {
    await _clear();
    _sessionManager.notifyPasswordChanged();
  });

  Future<void> _clear() async {
    await _tokenStorage.clear();
    try {
      await _localCache.clear();
    } on Object catch (_) {}
  }
}
