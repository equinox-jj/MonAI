import 'package:dio/dio.dart';
import 'package:monai/core/network/api_endpoints.dart';
import 'package:monai/core/storage/token_storage.dart';

/// Attaches `Authorization: Bearer <token>` unless the request is flagged
/// `noAuth`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final noAuth = options.extra[ApiEndpoints.kNoAuth] == true;
    if (!noAuth) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
