import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';

/// The localized text for auth errors.
extension AuthErrorText on AppLocalizations {
  /// The message under a field. Unknown codes, or a length code missing its
  /// limit, still mark the field as invalid.
  String fieldError(FieldError error) {
    final min = _intParam(error.params['min']);
    final max = _intParam(error.params['max']);
    return switch (error.code) {
      'required' => switch (error.field) {
        AuthInputValidator.nameField => authFieldNameRequired,
        AuthInputValidator.emailField => authFieldEmailRequired,
        _ => authFieldPasswordRequired,
      },
      'min_length' when min != null => authFieldTooShort(min),
      'max_length' when max != null => authFieldTooLong(max),
      'invalid_format' => authFieldEmailInvalid,
      'not_equal' => authFieldSameAsCurrent,
      'invalid_password' => changePasswordWrongCurrent,
      _ => authFieldInvalid,
    };
  }

  /// The banner text for [error].
  String formError(AuthFormError error) => switch (error) {
    InvalidCredentialsError() => authErrorInvalidCredentials,
    RateLimitedError(:final minutes?) => authErrorRateLimitedWait(minutes),
    RateLimitedError() => authErrorRateLimited,
    NetworkError() => authErrorNetwork,
    UnexpectedError() => authErrorUnexpected,
  };
}

/// The API sends limits as numbers; older payloads may send strings.
int? _intParam(Object? value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s),
  _ => null,
};
