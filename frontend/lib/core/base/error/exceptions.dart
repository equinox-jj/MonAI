import 'package:monai/core/base/error/field_error.dart';

/// Typed exceptions thrown in the data layer. Mapped from [DioException] by
/// `error_mapper.dart` and converted to `Failure` at the repository boundary.
///
/// [code] is the backend's `error.code` (e.g. `invalid_credentials`,
/// `wallet_has_transactions`) when the server sent one; the UI localizes from
/// it and falls back to [message].
sealed class AppException implements Exception {
  const AppException(this.message, this.code);

  /// Human-readable description of the failure (English fallback).
  final String message;

  /// Machine-readable backend error code, if any.
  final String? code;

  @override
  String toString() => '$runtimeType(${code ?? '-'}): $message';
}

/// No network connectivity / socket error.
class NetworkException extends AppException {
  const NetworkException({
    String message = 'No internet connection',
    String? code,
  }) : super(message, code);
}

/// Request exceeded a configured timeout.
class TimeoutException extends AppException {
  const TimeoutException({String message = 'Request timed out', String? code})
    : super(message, code);
}

/// HTTP 400.
class BadRequestException extends AppException {
  const BadRequestException({String message = 'Bad request', String? code})
    : super(message, code);
}

/// HTTP 401 — missing, expired or revoked token, or wrong credentials.
class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'Unauthorized', String? code})
    : super(message, code);
}

/// HTTP 403.
class ForbiddenException extends AppException {
  const ForbiddenException({String message = 'Forbidden', String? code})
    : super(message, code);
}

/// HTTP 404.
class NotFoundException extends AppException {
  const NotFoundException({String message = 'Not found', String? code})
    : super(message, code);
}

/// HTTP 409 — duplicate or state conflict.
class ConflictException extends AppException {
  const ConflictException({String message = 'Conflict', String? code})
    : super(message, code);
}

/// HTTP 422 — per-field validation errors.
class ValidationException extends AppException {
  const ValidationException(
    this.fieldErrors, {
    String message = 'Validation failed',
    String? code,
  }) : super(message, code);

  /// Every field error the server reported.
  final List<FieldError> fieldErrors;
}

/// HTTP 429.
class TooManyRequestsException extends AppException {
  const TooManyRequestsException({
    String message = 'Too many requests',
    String? code,
    this.retryAfter,
  }) : super(message, code);

  /// How long the server asks to wait (`Retry-After`), when it says.
  final Duration? retryAfter;
}

/// HTTP 503 — a dependency (e.g. the AI provider) is unavailable.
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

  /// The 5xx status code returned by the server.
  final int statusCode;
}

/// Request was cancelled.
class RequestCancelledException extends AppException {
  const RequestCancelledException({
    String message = 'Request cancelled',
    String? code,
  }) : super(message, code);
}

/// Anything not otherwise classified.
class UnknownException extends AppException {
  const UnknownException({String message = 'Unexpected error', String? code})
    : super(message, code);
}

/// Local storage / cache read or write failure.
class CacheException extends AppException {
  const CacheException({String message = 'Cache error', String? code})
    : super(message, code);
}
