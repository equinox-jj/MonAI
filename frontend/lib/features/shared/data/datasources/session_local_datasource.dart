import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/local_cache.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/data/storage/token_storage.dart';

abstract class SessionLocalDataSource {
  /// Only a token that fails to clear throws: once it is gone the user is
  /// signed out, and the next sign-in clears a cache left behind.
  Future<void> endSession();

  /// Like [endSession], but the app shows the password-changed dialog instead
  /// of going straight to Sign in.
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
