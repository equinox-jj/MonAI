import 'package:dio/dio.dart';
import 'package:monai/core/network/api_endpoints.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/storage/token_storage.dart';

/// Ends the session on HTTP 401: clears stored tokens and emits
/// [SessionManager.onSessionExpired], then passes the error on.
///
/// A 401 on an authenticated request means the token expired or was revoked.
/// Requests flagged `noAuth` (login, register) are skipped so a wrong password
/// does not log anyone out.
class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor({
    required this._tokenStorage,
    required this._sessionManager,
  });

  final TokenStorage _tokenStorage;
  final SessionManager _sessionManager;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isNoAuth = err.requestOptions.extra[ApiEndpoints.kNoAuth] == true;

    if (isUnauthorized && !isNoAuth) {
      await _tokenStorage.clear();
      _sessionManager.notifyExpired();
    }
    handler.next(err);
  }
}
