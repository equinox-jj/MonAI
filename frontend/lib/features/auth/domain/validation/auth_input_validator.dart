import 'dart:convert';

import 'package:monai/core/base/error/field_error.dart';

/// Mirrors the backend's rules (`backend/internal/auth/dto.go`), so a form
/// shows the same errors offline, and a login skips a round trip that counts
/// toward the rate limit. Errors use the server's field names, codes and
/// params. Takes input already cleaned up by `AuthInput`. Lengths count runes,
/// like the backend, except the password maximum, which counts bytes.
abstract final class AuthInputValidator {
  static const passwordMin = 8;

  static const _nameMax = 100;
  static const _emailMax = 254;

  /// bcrypt takes at most 72 bytes, so the server caps bytes, not characters.
  static const _passwordMaxBytes = 72;

  // Loose on purpose: catches typos without rejecting addresses the server
  // accepts.
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static const nameField = 'name';
  static const emailField = 'email';
  static const passwordField = 'password';
  static const currentPasswordField = 'current_password';
  static const newPasswordField = 'new_password';

  static bool isPasswordLongEnough(String password) =>
      password.runes.length >= passwordMin;

  static List<FieldError> register({
    required String name,
    required String email,
    required String password,
  }) => [
    ?registerName(name),
    ?registerEmail(email),
    ?registerPassword(password),
  ];

  static FieldError? registerName(String name) => _nameError(name);

  static FieldError? registerEmail(String email) =>
      _emailError(email, max: _emailMax);

  static FieldError? registerPassword(String password) =>
      _passwordError(password, min: passwordMin);

  /// The server has no password minimum on login, so a short one fails as wrong
  /// credentials.
  static List<FieldError> login({
    required String email,
    required String password,
  }) => [?loginEmail(email), ?loginPassword(password)];

  static FieldError? loginEmail(String email) => _emailError(email);

  static FieldError? loginPassword(String password) => _passwordError(password);

  /// The new password follows the register rules and must differ from the
  /// current one.
  static List<FieldError> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => [
    ?changeCurrentPassword(currentPassword),
    ?changeNewPassword(newPassword, currentPassword: currentPassword),
  ];

  static FieldError? changeCurrentPassword(String currentPassword) =>
      currentPassword.isEmpty ? _required(currentPasswordField) : null;

  static FieldError? changeNewPassword(
    String newPassword, {
    required String currentPassword,
  }) {
    final error = _passwordError(
      newPassword,
      min: passwordMin,
      field: newPasswordField,
    );
    if (error != null) return error;
    if (newPassword == currentPassword) {
      return const FieldError(
        field: newPasswordField,
        code: 'not_equal',
        message: 'must differ from current_password',
        params: {'other': currentPasswordField},
      );
    }
    return null;
  }

  static FieldError? _nameError(String name) {
    if (name.isEmpty) return _required(nameField);
    if (name.runes.length > _nameMax) return _tooLong(nameField, _nameMax);
    return null;
  }

  static FieldError? _emailError(String email, {int? max}) {
    if (email.isEmpty) return _required(emailField);
    if (max != null && email.runes.length > max) {
      return _tooLong(emailField, max);
    }
    if (!_email.hasMatch(email)) {
      return const FieldError(
        field: emailField,
        code: 'invalid_format',
        message: 'must be a valid email address',
      );
    }
    return null;
  }

  static FieldError? _passwordError(
    String password, {
    int? min,
    String field = passwordField,
  }) {
    if (password.isEmpty) return _required(field);
    if (min != null && password.runes.length < min) {
      return FieldError(
        field: field,
        code: 'min_length',
        message: 'must be at least $min characters',
        params: {'min': min},
      );
    }
    if (utf8.encode(password).length > _passwordMaxBytes) {
      return _tooLong(field, _passwordMaxBytes);
    }
    return null;
  }

  static FieldError _required(String field) =>
      FieldError(field: field, code: 'required', message: 'is required');

  static FieldError _tooLong(String field, int max) => FieldError(
    field: field,
    code: 'max_length',
    message: 'must be at most $max characters',
    params: {'max': max},
  );
}
