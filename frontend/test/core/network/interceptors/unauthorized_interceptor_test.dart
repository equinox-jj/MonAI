import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/network/api_endpoints.dart';
import 'package:monai/core/network/interceptors/unauthorized_interceptor.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/storage/token_storage.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockSessionManager extends Mock implements SessionManager {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

DioException _error(int status, {Map<String, dynamic>? extra}) {
  final options = RequestOptions(path: '/me', extra: extra);
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(requestOptions: options, statusCode: status),
  );
}

void main() {
  late _MockTokenStorage tokenStorage;
  late _MockSessionManager sessionManager;
  late _MockErrorHandler handler;
  late UnauthorizedInterceptor interceptor;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    sessionManager = _MockSessionManager();
    handler = _MockErrorHandler();
    interceptor = UnauthorizedInterceptor(
      tokenStorage: tokenStorage,
      sessionManager: sessionManager,
    );
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
  });

  test('clears tokens and emits expiry on 401', () async {
    final err = _error(401);

    await interceptor.onError(err, handler);

    verify(() => tokenStorage.clear()).called(1);
    verify(() => sessionManager.notifyExpired()).called(1);
    verify(() => handler.next(err)).called(1);
  });

  test('ignores 401 on noAuth requests (e.g. wrong password)', () async {
    final err = _error(401, extra: {ApiEndpoints.kNoAuth: true});

    await interceptor.onError(err, handler);

    verifyNever(() => tokenStorage.clear());
    verifyNever(() => sessionManager.notifyExpired());
    verify(() => handler.next(err)).called(1);
  });

  test('passes other errors through untouched', () async {
    final err = _error(500);

    await interceptor.onError(err, handler);

    verifyNever(() => tokenStorage.clear());
    verifyNever(() => sessionManager.notifyExpired());
    verify(() => handler.next(err)).called(1);
  });
}
