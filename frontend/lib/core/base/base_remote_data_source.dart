import 'package:dio/dio.dart';

import 'package:monai/core/base/error/error_mapper.dart';
import 'package:monai/core/base/error/exceptions.dart';

/// Mixed into remote data sources: wrap each request in [safeApiCall] to turn
/// a [DioException] into a typed [AppException].
mixin BaseRemoteDataSource {
  Future<T> safeApiCall<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }
}
