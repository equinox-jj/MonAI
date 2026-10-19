import 'dart:convert';

import 'package:monai/core/error/field_error.dart';

/// Checks auth forms on the device with the backend's rules
/// (`backend/internal/auth/dto.go`), so a form shows the same errors offline
/// as the server would send. The server stays the authority; this only saves
/// a round trip, which on login also counts toward the rate limit.
///
/// Errors use the server's field names, codes and params, so a local error
/// and a 422 reach the screen in the same shape. Takes input already cleaned
/// up by `AuthInput`. Lengths count runes, as the backend's validator does,
/// except the password maximum, which counts bytes.
abstract final class AuthInputValidator {
  /// Minimum password length in runes; the register screen shows it in its
  /// hint.
  static const passwordMin = 8;

  static const _nameMax = 100;
  static const _emailMax = 254;

  /// bcrypt takes at most 72 bytes, so the server caps bytes, not characters.
  static const _passwordMaxBytes = 72;

  // Loose on purpose: catches typos without rejecting addresses the server
  // accepts.
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Field names as the API sends them in `error.fields[].field`.
  static const nameField = 'name';
  static const emailField = 'email';
  static const passwordField = 'password';

  /// Whether [password] meets the minimum length; drives the register
  /// screen's live hint.
  static bool isPasswordLongEnough(String password) =>
      password.runes.length >= passwordMin;

  /// The problems with a register form, in field order; empty when valid.
  static List<FieldError> register({
    required String name,
    required String email,
    required String password,
  }) => [
    ?_nameError(name),
    ?_emailError(email, max: _emailMax),
    ?_passwordError(password, min: passwordMin),
  ];

  /// The problems with a login form; empty when valid. The server has no
  /// password minimum on login, so a short one fails as wrong credentials.
  static List<FieldError> login({
    required String email,
    required String password,
  }) => [?_emailError(email), ?_passwordError(password)];

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

  static FieldError? _passwordError(String password, {int? min}) {
    if (password.isEmpty) return _required(passwordField);
    if (min != null && password.runes.length < min) {
      return FieldError(
        field: passwordField,
        code: 'min_length',
        message: 'must be at least $min characters',
        params: {'min': min},
      );
    }
    if (utf8.encode(password).length > _passwordMaxBytes) {
      return _tooLong(passwordField, _passwordMaxBytes);
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
