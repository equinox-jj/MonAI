import 'package:monai/core/base/error/field_error.dart';

/// Thrown in the data layer and turned into a `Failure` at the repository.
/// [code] is the backend `error.code` the UI localizes from; [message] is the
/// English fallback.
sealed class AppException implements Exception {
  const AppException(this.message, this.code);
  final String message;
  final String? code;

  @override
  String toString() => '$runtimeType(${code ?? '-'}): $message';
}

class NetworkException extends AppException {
  const NetworkException({
    String message = 'No internet connection',
    String? code,
  }) : super(message, code);
}

class TimeoutException extends AppException {
  const TimeoutException({String message = 'Request timed out', String? code})
    : super(message, code);
}

class BadRequestException extends AppException {
  const BadRequestException({String message = 'Bad request', String? code})
    : super(message, code);
}

/// HTTP 401 — missing, expired or revoked token, or wrong credentials.
class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'Unauthorized', String? code})
    : super(message, code);
}

class ForbiddenException extends AppException {
  const ForbiddenException({String message = 'Forbidden', String? code})
    : super(message, code);
}

class NotFoundException extends AppException {
  const NotFoundException({String message = 'Not found', String? code})
    : super(message, code);
}

class ConflictException extends AppException {
  const ConflictException({String message = 'Conflict', String? code})
    : super(message, code);
}

class ValidationException extends AppException {
  const ValidationException(
    this.fieldErrors, {
    String message = 'Validation failed',
    String? code,
  }) : super(message, code);

  final List<FieldError> fieldErrors;
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException({
    String message = 'Too many requests',
    String? code,
    this.retryAfter,
  }) : super(message, code);

  final Duration? retryAfter;
}

class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException({
    String message = 'Service unavailable',
    String? code,
  }) : super(message, code);
}

/// HTTP 5xx other than 503.
class ServerException extends AppException {
  const ServerException(
    this.statusCode, {
    String message = 'Server error',
    String? code,
  }) : super(message, code);

  final int statusCode;
}

class RequestCancelledException extends AppException {
  const RequestCancelledException({
    String message = 'Request cancelled',
    String? code,
  }) : super(message, code);
}

class UnknownException extends AppException {
  const UnknownException({String message = 'Unexpected error', String? code})
    : super(message, code);
}

class CacheException extends AppException {
  const CacheException({String message = 'Cache error', String? code})
    : super(message, code);
}
