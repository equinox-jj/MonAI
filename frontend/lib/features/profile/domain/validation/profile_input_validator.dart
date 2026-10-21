import 'package:monai/core/base/error/field_error.dart';

/// The backend's rules for the profile, checked on the device first, in the
/// shape of the server's own 422.
abstract final class ProfileInputValidator {
  static const nameField = 'name';
  static const passwordField = 'password';

  /// The API's limit for a display name.
  static const nameMaxLength = 100;

  /// [name] as it is saved: without surrounding spaces.
  static String normalizedName(String name) => name.trim();

  /// The error of a normalized display [name], or null when it is valid.
  static FieldError? name(String name) => switch (name) {
    '' => const FieldError(
      field: nameField,
      code: 'required',
      message: 'is required',
    ),
    _ when name.length > nameMaxLength => const FieldError(
      field: nameField,
      code: 'max_length',
      message: 'must be at most 100 characters',
      params: {'max': nameMaxLength},
    ),
    _ => null,
  };

  /// The error of the password confirming a delete, or null when given.
  static FieldError? password(String password) => password.isEmpty
      ? const FieldError(
          field: passwordField,
          code: 'required',
          message: 'is required',
        )
      : null;
}
