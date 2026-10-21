import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/field_error.dart';

part 'failure.freezed.dart';

/// [code] is the backend `error.code` the UI localizes from; [message] is the
/// English fallback.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({
    @Default('No internet connection') String message,
    String? code,
  }) = NetworkFailure;

  const factory Failure.timeout({
    @Default('Request timed out') String message,
    String? code,
  }) = TimeoutFailure;

  const factory Failure.badRequest({
    @Default('Bad request') String message,
    String? code,
  }) = BadRequestFailure;

  /// HTTP 401 (session expired, revoked token or wrong credentials).
  const factory Failure.unauthorized({
    @Default('Unauthorized') String message,
    String? code,
  }) = UnauthorizedFailure;

  const factory Failure.forbidden({
    @Default('Forbidden') String message,
    String? code,
  }) = ForbiddenFailure;

  const factory Failure.notFound({
    @Default('Not found') String message,
    String? code,
  }) = NotFoundFailure;

  const factory Failure.conflict({
    @Default('Conflict') String message,
    String? code,
  }) = ConflictFailure;

  const factory Failure.validation(
    List<FieldError> fieldErrors, {
    @Default('Validation failed') String message,
    String? code,
  }) = ValidationFailure;

  const factory Failure.tooManyRequests({
    @Default('Too many requests') String message,
    String? code,
    Duration? retryAfter,
  }) = TooManyRequestsFailure;

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

  const factory Failure.cache({
    @Default('Cache error') String message,
    String? code,
  }) = CacheFailure;

  const factory Failure.unknown({
    @Default('Unexpected error') String message,
    String? code,
  }) = UnknownFailure;
}
