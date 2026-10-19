import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/features/auth/domain/validation/auth_input.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';

List<(String, String)> _codes(List<FieldError> errors) =>
    errors.map((e) => (e.field, e.code)).toList();

void main() {
  group('AuthInput', () {
    test('trims the name and trims and lowercases the email', () {
      // Arrange
      const name = '  Ana Putri ';
      const email = ' Ana@Example.COM ';

      // Act
      final cleanName = name.normalizedName;
      final cleanEmail = email.normalizedEmail;

      // Assert
      expect(cleanName, 'Ana Putri');
      expect(cleanEmail, 'ana@example.com');
    });
  });

  group('login', () {
    test('a valid form has no errors', () {
      // Arrange
      // A short password is not checked: the server fails it as wrong
      // credentials.

      // Act
      final errors = AuthInputValidator.login(email: 'a@b.co', password: 'x');

      // Assert
      expect(errors, isEmpty);
    });

    test('flags empty fields as required', () {
      // Arrange
      // (an empty form)

      // Act
      final errors = AuthInputValidator.login(email: '', password: '');

      // Assert
      expect(_codes(errors), [('email', 'required'), ('password', 'required')]);
    });

    test('flags a malformed email', () {
      // Arrange
      const email = 'not-an-email';

      // Act
      final errors = AuthInputValidator.login(email: email, password: 'pw');

      // Assert
      expect(_codes(errors), [('email', 'invalid_format')]);
    });
  });

  group('register', () {
    test('a valid form has no errors', () {
      // Arrange
      // (a valid form)

      // Act
      final errors = AuthInputValidator.register(
        name: 'Ana',
        email: 'a@b.co',
        password: 'password',
      );

      // Assert
      expect(errors, isEmpty);
    });

    test('a password shorter than 8 runes is too short', () {
      // Arrange
      const password = 'short';

      // Act
      final errors = AuthInputValidator.register(
        name: 'Ana',
        email: 'a@b.co',
        password: password,
      );

      // Assert
      expect(errors.single.code, 'min_length');
      expect(errors.single.params, {'min': 8});
    });

    test('the password maximum counts bytes, not characters', () {
      // Arrange
      // 25 three-byte characters: 25 runes but 75 bytes.
      final password = '€' * 25;

      // Act
      final errors = AuthInputValidator.register(
        name: 'Ana',
        email: 'a@b.co',
        password: password,
      );

      // Assert
      expect(_codes(errors), [('password', 'max_length')]);
      expect(errors.single.params, {'max': 72});
    });

    test('lengths count runes, so emoji count once', () {
      // Arrange
      // 8 emoji: 16 UTF-16 code units but 8 runes; 100 emoji as a name.
      final password = '😀' * 8;
      final name = '😀' * 100;

      // Act
      final errors = AuthInputValidator.register(
        name: name,
        email: 'a@b.co',
        password: password,
      );

      // Assert
      expect(errors, isEmpty);
    });

    test('flags a name over 100 runes and an email over 254', () {
      // Arrange
      final name = 'a' * 101;
      final email = '${'a' * 250}@b.co';

      // Act
      final errors = AuthInputValidator.register(
        name: name,
        email: email,
        password: 'password',
      );

      // Assert
      expect(_codes(errors), [('name', 'max_length'), ('email', 'max_length')]);
    });

    test('isPasswordLongEnough follows the minimum', () {
      // Arrange
      const short = '1234567';
      const enough = '12345678';

      // Act
      final shortResult = AuthInputValidator.isPasswordLongEnough(short);
      final enoughResult = AuthInputValidator.isPasswordLongEnough(enough);

      // Assert
      expect(shortResult, isFalse);
      expect(enoughResult, isTrue);
    });
  });

  group('changePassword', () {
    test('a different new password long enough is valid', () {
      // Arrange
      const current = 'old-secret';
      const next = 'new-secret';

      // Act
      final errors = AuthInputValidator.changePassword(
        currentPassword: current,
        newPassword: next,
      );

      // Assert
      expect(errors, isEmpty);
    });

    test('both passwords are required', () {
      // Arrange
      const empty = '';

      // Act
      final errors = AuthInputValidator.changePassword(
        currentPassword: empty,
        newPassword: empty,
      );

      // Assert
      expect(_codes(errors), [
        ('current_password', 'required'),
        ('new_password', 'required'),
      ]);
    });

    test('the new password follows the register minimum', () {
      // Arrange
      const short = 'short';

      // Act
      final errors = AuthInputValidator.changePassword(
        currentPassword: 'old-secret',
        newPassword: short,
      );

      // Assert
      expect(_codes(errors), [('new_password', 'min_length')]);
    });

    test('the new password must differ from the current one', () {
      // Arrange
      const same = 'same-secret';

      // Act
      final errors = AuthInputValidator.changePassword(
        currentPassword: same,
        newPassword: same,
      );

      // Assert
      expect(_codes(errors), [('new_password', 'not_equal')]);
      expect(errors.single.params, {'other': 'current_password'});
    });
  });
}
