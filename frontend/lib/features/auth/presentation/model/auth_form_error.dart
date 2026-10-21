import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/error/failure.dart';

part 'auth_form_error.freezed.dart';

/// A form field, used to move focus to the first one with an error.
enum AuthField { name, email, password, currentPassword, newPassword }

/// A problem with the whole attempt rather than one field, shown as a
/// banner above the form.
@freezed
sealed class AuthFormError with _$AuthFormError {
  /// Wrong email or password; the API does not say which.
  const factory AuthFormError.invalidCredentials() = InvalidCredentialsError;

  /// Too many attempts. [minutes] is the server's wait, rounded up so the
  /// user never retries too early; null when it didn't say.
  const factory AuthFormError.rateLimited({int? minutes}) = RateLimitedError;

  /// The server could not be reached.
  const factory AuthFormError.network() = NetworkError;

  /// Anything else.
  const factory AuthFormError.unexpected() = UnexpectedError;

  /// The banner for [failure]. Field-level failures (validation, a taken
  /// email) are shown on their fields; one that reaches here falls back to
  /// [AuthFormError.unexpected].
  factory AuthFormError.fromFailure(Failure failure) => switch (failure) {
    UnauthorizedFailure() => const .invalidCredentials(),
    TooManyRequestsFailure(:final retryAfter) => .rateLimited(
      minutes: switch (retryAfter) {
        final wait? => max(1, (wait.inSeconds + 59) ~/ 60),
        null => null,
      },
    ),
    NetworkFailure() || TimeoutFailure() => const .network(),
    BadRequestFailure() ||
    ForbiddenFailure() ||
    NotFoundFailure() ||
    ConflictFailure() ||
    ValidationFailure() ||
    ServiceUnavailableFailure() ||
    ServerFailure() ||
    CacheFailure() ||
    UnknownFailure() => const .unexpected(),
  };
}
