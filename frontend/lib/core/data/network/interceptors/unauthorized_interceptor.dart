import 'package:dio/dio.dart';
import 'package:monai/core/data/database/local_cache.dart';
import 'package:monai/core/data/network/api_endpoints.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/data/storage/token_storage.dart';

/// Ends the session on HTTP 401: clears the stored token and the offline
/// cache, marks the session expired, then passes the error on.
///
/// A 401 on an authenticated request means the token expired or was revoked.
/// Requests flagged `noAuth` (login, register) are skipped so a wrong password
/// does not log anyone out. A 401 for a token that is no longer stored (a
/// late reply from before a newer sign-in) is ignored too, so it can't end the
/// new session.
class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor({
    required this._tokenStorage,
    required this._localCache,
    required this._sessionManager,
  });

  final TokenStorage _tokenStorage;
  final LocalCache _localCache;
  final SessionManager _sessionManager;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isNoAuth = err.requestOptions.extra[ApiEndpoints.kNoAuth] == true;

    if (isUnauthorized && !isNoAuth && await _isCurrentToken(err)) {
      await _tokenStorage.clear();
      // The token is already gone, so a cache that fails to clear doesn't
      // stop the expiry; the next sign-in clears it before its session starts.
      try {
        await _localCache.clear();
      } on Object catch (_) {}
      _sessionManager.notifyExpired();
    }
    handler.next(err);
  }

  Future<bool> _isCurrentToken(DioException err) async {
    final stored = await _tokenStorage.readAccessToken();
    if (stored == null || stored.isEmpty) return false;
    return err.requestOptions.headers['Authorization'] == 'Bearer $stored';
  }
}
