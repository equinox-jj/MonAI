import 'package:dio/dio.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';

// Re-export so callers that import only error_mapper.dart also get the Failure
// subtypes (e.g. ValidationFailure, UnknownFailure) and FieldError without a
// separate import.
export 'package:monai/core/error/failure.dart';
export 'package:monai/core/error/field_error.dart';

/// Converts a [DioException] into a typed [AppException].
AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutException();
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.cancel:
      return const RequestCancelledException();
    case DioExceptionType.badCertificate:
      return const NetworkException(message: 'Bad certificate');
    case DioExceptionType.badResponse:
      return _mapResponse(e.response);
    case DioExceptionType.unknown:
      if (e.error is FormatException) {
        return const UnknownException(message: 'Malformed response');
      }
      return const NetworkException();
  }
}

/// Maps the backend error envelope
/// `{success: false, message, data: null, error: {code, fields?}}`.
AppException _mapResponse(Response<dynamic>? response) {
  final status = response?.statusCode ?? 0;
  final data = response?.data;
  final message = _extractMessage(data);
  final code = _extractCode(data);
  switch (status) {
    case 400:
      return BadRequestException(message: message ?? 'Bad request', code: code);
    case 401:
      return UnauthorizedException(
        message: message ?? 'Unauthorized',
        code: code,
      );
    case 403:
      return ForbiddenException(message: message ?? 'Forbidden', code: code);
    case 404:
      return NotFoundException(message: message ?? 'Not found', code: code);
    case 409:
      return ConflictException(message: message ?? 'Conflict', code: code);
    case 422:
      return ValidationException(
        parseFieldErrors(data),
        message: message ?? 'Validation failed',
        code: code,
      );
    case 429:
      return TooManyRequestsException(
        message: message ?? 'Too many requests',
        code: code,
      );
    case 503:
      return ServiceUnavailableException(
        message: message ?? 'Service unavailable',
        code: code,
      );
    default:
      if (status >= 500) {
        return ServerException(
          status,
          message: message ?? 'Server error',
          code: code,
        );
      }
      return UnknownException(
        message: message ?? 'Unexpected error ($status)',
        code: code,
      );
  }
}

String? _extractMessage(Object? data) {
  if (data is Map && data['message'] is String) {
    final message = data['message'] as String;
    if (message.isNotEmpty) return message;
  }
  return null;
}

String? _extractCode(Object? data) {
  if (data is! Map) return null;
  final error = data['error'];
  if (error is Map && error['code'] is String) {
    return error['code'] as String;
  }
  return null;
}

/// Parses `error.fields[]` of a 422 body into [FieldError]s. Returns an empty
/// list when the body has no fields.
List<FieldError> parseFieldErrors(Object? data) {
  if (data is! Map) return const [];
  final error = data['error'];
  if (error is! Map) return const [];
  final fields = error['fields'];
  if (fields is! List) return const [];
  return [
    for (final item in fields)
      if (item is Map) FieldError.fromJson(item),
  ];
}

/// Converts any thrown error (typically [AppException]) into a domain [Failure].
Failure mapExceptionToFailure(Object error) {
  if (error is AppException) {
    final message = error.message;
    final code = error.code;
    return switch (error) {
      NetworkException() => Failure.network(message: message, code: code),
      TimeoutException() => Failure.timeout(message: message, code: code),
      BadRequestException() => Failure.badRequest(message: message, code: code),
      UnauthorizedException() => Failure.unauthorized(
        message: message,
        code: code,
      ),
      ForbiddenException() => Failure.forbidden(message: message, code: code),
      NotFoundException() => Failure.notFound(message: message, code: code),
      ConflictException() => Failure.conflict(message: message, code: code),
      ValidationException(:final fieldErrors) => Failure.validation(
        fieldErrors,
        message: message,
        code: code,
      ),
      TooManyRequestsException() => Failure.tooManyRequests(
        message: message,
        code: code,
      ),
      ServiceUnavailableException() => Failure.serviceUnavailable(
        message: message,
        code: code,
      ),
      ServerException(:final statusCode) => Failure.server(
        statusCode,
        message: message,
        code: code,
      ),
      RequestCancelledException() => Failure.unknown(
        message: message,
        code: code,
      ),
      UnknownException() => Failure.unknown(message: message, code: code),
      CacheException() => Failure.cache(message: message, code: code),
    };
  }
  return Failure.unknown(message: error.toString());
}
