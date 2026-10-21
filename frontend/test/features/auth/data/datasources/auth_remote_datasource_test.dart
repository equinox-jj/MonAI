import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/data/network/api_endpoints.dart';
import 'package:monai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:monai/features/auth/data/datasources/endpoint/auth_endpoint.dart';
import 'package:monai/features/auth/data/model/change_password_request.dart';
import 'package:monai/features/auth/data/model/login_request.dart';
import 'package:monai/features/auth/data/model/register_request.dart';

class _MockDio extends Mock implements Dio {}

const _body = {
  'success': true,
  'message': 'ok',
  'data': {
    'access_token': 'token',
    'token_type': 'Bearer',
    'expires_in': 3600,
    'user': {
      'id': 'u1',
      'name': 'Ana',
      'email': 'a@b.co',
      'role': {'slug': 'user', 'name': 'User'},
      'permissions': ['wallets:read'],
      'created_at': '2026-10-01T00:00:00Z',
    },
  },
};

Response<Map<String, dynamic>> _ok(String path) => Response(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: _body,
);

void main() {
  late _MockDio dio;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: dio);
  });

  test('login posts the credentials without a token', () async {
    // Arrange
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => _ok(AuthEndpoint.login));

    // Act
    final response = await dataSource.login(
      const LoginRequest(email: 'a@b.co', password: 'pw'),
    );

    // Assert
    final call = verify(
      () => dio.post<Map<String, dynamic>>(
        AuthEndpoint.login,
        data: captureAny(named: 'data'),
        options: captureAny(named: 'options'),
      ),
    )..called(1);
    expect(call.captured[0], {'email': 'a@b.co', 'password': 'pw'});
    expect((call.captured[1] as Options).extra?[ApiEndpoints.kNoAuth], isTrue);
    expect(response.data?.accessToken, 'token');
    expect(response.data?.user?.role?.slug, 'user');
  });

  test('register posts the form without a token', () async {
    // Arrange
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => _ok(AuthEndpoint.register));

    // Act
    await dataSource.register(
      const RegisterRequest(name: 'Ana', email: 'a@b.co', password: 'pw'),
    );

    // Assert
    final call = verify(
      () => dio.post<Map<String, dynamic>>(
        AuthEndpoint.register,
        data: captureAny(named: 'data'),
        options: captureAny(named: 'options'),
      ),
    )..called(1);
    expect(call.captured[0], {
      'name': 'Ana',
      'email': 'a@b.co',
      'password': 'pw',
    });
    expect((call.captured[1] as Options).extra?[ApiEndpoints.kNoAuth], isTrue);
  });

  test('a 401 becomes an UnauthorizedException with its code', () async {
    // Arrange
    final options = RequestOptions(path: AuthEndpoint.login);
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 401,
          data: {
            'success': false,
            'message': 'Invalid email or password',
            'error': {'code': 'invalid_credentials'},
          },
        ),
      ),
    );

    // Act
    final call = dataSource.login(
      const LoginRequest(email: 'a@b.co', password: 'pw'),
    );

    // Assert
    await expectLater(
      call,
      throwsA(
        isA<UnauthorizedException>().having(
          (e) => e.code,
          'code',
          'invalid_credentials',
        ),
      ),
    );
  });

  test('changePassword puts both passwords', () async {
    // Arrange
    when(() => dio.put<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer((_) async => _ok(AuthEndpoint.password));

    // Act
    await dataSource.changePassword(
      const ChangePasswordRequest(currentPassword: 'old', newPassword: 'new'),
    );

    // Assert
    final body = verify(
      () => dio.put<Map<String, dynamic>>(
        AuthEndpoint.password,
        data: captureAny(named: 'data'),
      ),
    ).captured.single;
    expect(body, {'current_password': 'old', 'new_password': 'new'});
  });
}
