import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/data/database/local_cache.dart';
import 'package:monai/core/data/network/api_endpoints.dart';
import 'package:monai/core/data/network/interceptors/unauthorized_interceptor.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/data/storage/token_storage.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLocalCache extends Mock implements LocalCache {}

class _MockSessionManager extends Mock implements SessionManager {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

const _token = 'current-token';

DioException _error(
  int status, {
  String? token = _token,
  Map<String, dynamic>? extra,
}) {
  final options = RequestOptions(
    path: '/me',
    extra: extra,
    headers: {'Authorization': ?(token == null ? null : 'Bearer $token')},
  );
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(requestOptions: options, statusCode: status),
  );
}

void main() {
  late _MockTokenStorage tokenStorage;
  late _MockLocalCache localCache;
  late _MockSessionManager sessionManager;
  late _MockErrorHandler handler;
  late UnauthorizedInterceptor interceptor;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    localCache = _MockLocalCache();
    sessionManager = _MockSessionManager();
    handler = _MockErrorHandler();
    interceptor = UnauthorizedInterceptor(
      tokenStorage: tokenStorage,
      localCache: localCache,
      sessionManager: sessionManager,
    );
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => _token);
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
    when(() => localCache.clear()).thenAnswer((_) async {});
  });

  test('clears the token and cache and expires the session on 401', () async {
    // Arrange
    final err = _error(401);

    // Act
    await interceptor.onError(err, handler);

    // Assert
    verify(() => tokenStorage.clear()).called(1);
    verify(() => localCache.clear()).called(1);
    verify(() => sessionManager.notifyExpired()).called(1);
    verify(() => handler.next(err)).called(1);
  });

  test('still expires the session when the cache fails to clear', () async {
    // Arrange
    final err = _error(401);
    when(() => localCache.clear()).thenThrow(Exception('disk'));

    // Act
    await interceptor.onError(err, handler);

    // Assert
    verify(() => tokenStorage.clear()).called(1);
    verify(() => sessionManager.notifyExpired()).called(1);
    verify(() => handler.next(err)).called(1);
  });

  test('ignores a 401 for a token that is no longer stored', () async {
    // Arrange
    final err = _error(401, token: 'old-token');

    // Act
    await interceptor.onError(err, handler);

    // Assert
    verifyNever(() => tokenStorage.clear());
    verifyNever(() => localCache.clear());
    verifyNever(() => sessionManager.notifyExpired());
    verify(() => handler.next(err)).called(1);
  });

  test('ignores a 401 when no token is stored', () async {
    // Arrange
    final err = _error(401);
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => null);

    // Act
    await interceptor.onError(err, handler);

    // Assert
    verifyNever(() => tokenStorage.clear());
    verifyNever(() => sessionManager.notifyExpired());
    verify(() => handler.next(err)).called(1);
  });

  test('ignores 401 on noAuth requests (e.g. wrong password)', () async {
    // Arrange
    final err = _error(401, token: null, extra: {ApiEndpoints.kNoAuth: true});

    // Act
    await interceptor.onError(err, handler);

    // Assert
    verifyNever(() => tokenStorage.clear());
    verifyNever(() => sessionManager.notifyExpired());
    verify(() => handler.next(err)).called(1);
  });

  test('passes other errors through untouched', () async {
    // Arrange
    final err = _error(500);

    // Act
    await interceptor.onError(err, handler);

    // Assert
    verifyNever(() => tokenStorage.clear());
    verifyNever(() => sessionManager.notifyExpired());
    verify(() => handler.next(err)).called(1);
  });
}
