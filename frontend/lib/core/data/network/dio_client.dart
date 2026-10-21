import 'package:dio/dio.dart';
import 'package:monai/core/data/network/api_endpoints.dart';
import 'package:monai/core/data/network/interceptors/auth_interceptor.dart';
import 'package:monai/core/data/network/interceptors/logger_interceptor.dart';
import 'package:monai/core/data/network/interceptors/unauthorized_interceptor.dart';

class DioClient {
  DioClient({
    required AuthInterceptor authInterceptor,
    required UnauthorizedInterceptor unauthorizedInterceptor,
    Dio? dio,
  }) : dio = dio ?? Dio() {
    this.dio
      ..options = BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        // AI parsing and receipt OCR responses can take a while.
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      )
      ..interceptors.addAll([
        authInterceptor,
        unauthorizedInterceptor,
        LoggerInterceptor(),
      ]);
  }

  final Dio dio;
}
