import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/session_endpoint.dart';

abstract class SessionRemoteDataSource {
  /// `POST /auth/logout-all`.
  Future<void> logoutAll();
}

class SessionRemoteDataSourceImpl extends SessionRemoteDataSource
    with BaseRemoteDataSource {
  SessionRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<void> logoutAll() => safeApiCall(() async {
    await _dio.post<Map<String, dynamic>>(SessionEndpoint.logoutAll);
  });
}
