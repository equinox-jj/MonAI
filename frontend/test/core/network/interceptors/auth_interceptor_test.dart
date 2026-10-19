import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/network/api_endpoints.dart';
import 'package:monai/core/network/interceptors/auth_interceptor.dart';
import 'package:monai/core/storage/token_storage.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late _MockTokenStorage tokenStorage;
  late _MockRequestHandler handler;
  late AuthInterceptor interceptor;

  setUpAll(() => registerFallbackValue(RequestOptions()));

  setUp(() {
    tokenStorage = _MockTokenStorage();
    handler = _MockRequestHandler();
    interceptor = AuthInterceptor(tokenStorage);
  });

  test('attaches the bearer token', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => 'abc');
    final options = RequestOptions(path: '/me');

    await interceptor.onRequest(options, handler);

    expect(options.headers['Authorization'], 'Bearer abc');
    verify(() => handler.next(options)).called(1);
  });

  test('skips the header when no token is stored', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => null);
    final options = RequestOptions(path: '/me');

    await interceptor.onRequest(options, handler);

    expect(options.headers.containsKey('Authorization'), isFalse);
    verify(() => handler.next(options)).called(1);
  });

  test('skips the token for noAuth requests', () async {
    final options = RequestOptions(
      path: '/auth/login',
      extra: {ApiEndpoints.kNoAuth: true},
    );

    await interceptor.onRequest(options, handler);

    expect(options.headers.containsKey('Authorization'), isFalse);
    verifyNever(() => tokenStorage.readAccessToken());
    verify(() => handler.next(options)).called(1);
  });
}
