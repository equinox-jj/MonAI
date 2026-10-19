import 'package:dio/dio.dart';

import 'package:monai/core/error/error_mapper.dart';
import 'package:monai/core/error/exceptions.dart';

/// Mixed into remote data sources to centralize DioException → AppException
/// translation. Data sources call [safeApiCall] around each request.
mixin BaseRemoteDataSource {
  /// Runs [request], translating any [DioException] into the matching
  /// [AppException]. [AppException]s thrown inside [request] pass through;
  /// anything else becomes an [UnknownException].
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
