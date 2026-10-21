import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';

part 'auth_form_error.freezed.dart';

enum AuthField { name, email, password, currentPassword, newPassword }

@freezed
sealed class AuthFormError with _$AuthFormError {
  const factory AuthFormError.invalidCredentials() = InvalidCredentialsError;

  /// [minutes] is the server's wait, rounded up so the user never retries too
  /// early; null when it didn't say.
  const factory AuthFormError.rateLimited({int? minutes}) = RateLimitedError;
  const factory AuthFormError.network() = NetworkError;
  const factory AuthFormError.unexpected() = UnexpectedError;

  /// Field-level failures (validation, a taken email) show on their fields; one
  /// that reaches here falls back to [AuthFormError.unexpected].
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
