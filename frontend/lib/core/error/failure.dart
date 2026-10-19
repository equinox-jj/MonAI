import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/error/field_error.dart';

part 'failure.freezed.dart';

/// Domain-layer error type returned inside `Either<Failure, T>`.
/// Consume with a Dart 3 `switch` expression on the sealed union.
///
/// [code] carries the backend's `error.code` so the UI can show localized
/// text; [message] is the English fallback.
@freezed
sealed class Failure with _$Failure {
  /// No connectivity.
  const factory Failure.network({
    @Default('No internet connection') String message,
    String? code,
  }) = NetworkFailure;

  /// Timeout.
  const factory Failure.timeout({
    @Default('Request timed out') String message,
    String? code,
  }) = TimeoutFailure;

  /// HTTP 400.
  const factory Failure.badRequest({
    @Default('Bad request') String message,
    String? code,
  }) = BadRequestFailure;

  /// HTTP 401 (session expired, revoked token or wrong credentials).
  const factory Failure.unauthorized({
    @Default('Unauthorized') String message,
    String? code,
  }) = UnauthorizedFailure;

  /// HTTP 403.
  const factory Failure.forbidden({
    @Default('Forbidden') String message,
    String? code,
  }) = ForbiddenFailure;

  /// HTTP 404.
  const factory Failure.notFound({
    @Default('Not found') String message,
    String? code,
  }) = NotFoundFailure;

  /// HTTP 409.
  const factory Failure.conflict({
    @Default('Conflict') String message,
    String? code,
  }) = ConflictFailure;

  /// HTTP 422 — per-field validation errors.
  const factory Failure.validation(
    List<FieldError> fieldErrors, {
    @Default('Validation failed') String message,
    String? code,
  }) = ValidationFailure;

  /// HTTP 429. [retryAfter] is the server's `Retry-After`, when it sent one.
  const factory Failure.tooManyRequests({
    @Default('Too many requests') String message,
    String? code,
    Duration? retryAfter,
  }) = TooManyRequestsFailure;

  /// HTTP 503.
  const factory Failure.serviceUnavailable({
    @Default('Service unavailable') String message,
    String? code,
  }) = ServiceUnavailableFailure;

  /// HTTP 5xx other than 503.
  const factory Failure.server(
    int statusCode, {
    @Default('Server error') String message,
    String? code,
  }) = ServerFailure;

  /// Local storage / cache error.
  const factory Failure.cache({
    @Default('Cache error') String message,
    String? code,
  }) = CacheFailure;

  /// Unclassified error.
  const factory Failure.unknown({
    @Default('Unexpected error') String message,
    String? code,
  }) = UnknownFailure;
}
