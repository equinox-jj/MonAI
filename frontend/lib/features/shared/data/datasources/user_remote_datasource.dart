import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/user_endpoint.dart';
import 'package:monai/features/shared/data/model/me_response.dart';

abstract class UserRemoteDataSource {
  Future<MeResponse> getMe();
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource
    with BaseRemoteDataSource {
  UserRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<MeResponse> getMe() => safeApiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(UserEndpoint.me);
    return MeResponse.fromJson(response.data ?? const {});
  });
}
