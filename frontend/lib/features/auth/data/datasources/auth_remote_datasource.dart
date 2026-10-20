import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/core/network/api_endpoints.dart';
import 'package:monai/features/auth/data/datasources/endpoint/auth_endpoint.dart';
import 'package:monai/features/auth/data/model/auth_response.dart';
import 'package:monai/features/auth/data/model/change_password_request.dart';
import 'package:monai/features/auth/data/model/login_request.dart';
import 'package:monai/features/auth/data/model/register_request.dart';

abstract class AuthRemoteDataSource {
  /// `POST /auth/login`.
  Future<AuthResponse> login(LoginRequest request);

  /// `POST /auth/register`.
  Future<AuthResponse> register(RegisterRequest request);

  /// `PUT /auth/password`.
  Future<AuthResponse> changePassword(ChangePasswordRequest request);
}

/// Sends login and register without a token: a 401 there means wrong
/// credentials, not an expired session.
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource
    with BaseRemoteDataSource {
  AuthRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  static final _noAuth = Options(extra: {ApiEndpoints.kNoAuth: true});

  @override
  Future<AuthResponse> login(LoginRequest request) =>
      _post(AuthEndpoint.login, request.toJson());

  @override
  Future<AuthResponse> register(RegisterRequest request) =>
      _post(AuthEndpoint.register, request.toJson());

  @override
  Future<AuthResponse> changePassword(ChangePasswordRequest request) =>
      safeApiCall(() async {
        final response = await _dio.put<Map<String, dynamic>>(
          AuthEndpoint.password,
          data: request.toJson(),
        );
        return AuthResponse.fromJson(response.data ?? const {});
      });

  Future<AuthResponse> _post(String path, Map<String, dynamic> body) =>
      safeApiCall(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          path,
          data: body,
          options: _noAuth,
        );
        return AuthResponse.fromJson(response.data ?? const {});
      });
}
