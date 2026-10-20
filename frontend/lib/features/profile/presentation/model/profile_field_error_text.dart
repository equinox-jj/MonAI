import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/profile/domain/validation/profile_input_validator.dart';

extension ProfileFieldErrorText on FieldError {
  /// The message under the field, from the device's checks or the server's.
  String text(AppLocalizations l10n) => switch ((field, code)) {
    (ProfileInputValidator.nameField, 'required') =>
      l10n.profileErrorNameRequired,
    (ProfileInputValidator.nameField, 'max_length' || 'max') =>
      l10n.profileErrorNameTooLong(
        (params['max'] as num?)?.toInt() ?? ProfileInputValidator.nameMaxLength,
      ),
    (ProfileInputValidator.nameField, _) => l10n.profileErrorNameInvalid,
    (ProfileInputValidator.passwordField, 'invalid_password') =>
      l10n.profileErrorWrongPassword,
    (ProfileInputValidator.passwordField, _) =>
      l10n.profileErrorPasswordRequired,
    _ => message,
  };
}
