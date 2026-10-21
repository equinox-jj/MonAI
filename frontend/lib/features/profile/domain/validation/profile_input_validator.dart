import 'package:monai/core/base/error/field_error.dart';

abstract final class ProfileInputValidator {
  static const nameField = 'name';
  static const passwordField = 'password';
  static const nameMaxLength = 100;

  static String normalizedName(String name) => name.trim();

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

  static FieldError? password(String password) => password.isEmpty
      ? const FieldError(
          field: passwordField,
          code: 'required',
          message: 'is required',
        )
      : null;
}
