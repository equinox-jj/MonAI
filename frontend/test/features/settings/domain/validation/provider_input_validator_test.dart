import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';

ProviderInput _input({
  String name = 'GoPay',
  List<String> aliases = const [],
}) => ProviderInput(
  name: name,
  type: WalletType.eWallet,
  aliases: aliases,
  sortOrder: 50,
  isActive: true,
);

void main() {
  group('normalized', () {
    test('trims the name and cleans up the aliases', () {
      // Arrange
      final input = _input(
        name: '  GoPay ',
        aliases: [' GPay', 'gopay', '', 'gpay', 'Go-Pay '],
      );

      // Act
      final normalized = ProviderInputValidator.normalized(input);

      // Assert
      expect(normalized.name, 'GoPay');
      expect(normalized.aliases, ['go-pay', 'gopay', 'gpay']);
    });
  });

  group('validate', () {
    test('a named provider with few short aliases is valid', () {
      // Arrange
      final input = _input(aliases: ['gopay']);

      // Act
      final errors = ProviderInputValidator.validate(input);

      // Assert
      expect(errors, isEmpty);
    });

    test('a blank name is required', () {
      // Arrange
      final input = _input(name: '');

      // Act
      final errors = ProviderInputValidator.validate(input);

      // Assert
      expect(errors.single.field, 'name');
      expect(errors.single.code, 'required');
    });

    test('a name over 50 characters is too long', () {
      // Arrange
      final input = _input(name: 'x' * 51);

      // Act
      final errors = ProviderInputValidator.validate(input);

      // Assert
      expect(errors.single.code, 'max_length');
      expect(errors.single.params, {'max': 50});
    });

    test('more than 20 aliases are too many', () {
      // Arrange
      final input = _input(aliases: List.generate(21, (i) => 'a$i'));

      // Act
      final errors = ProviderInputValidator.validate(input);

      // Assert
      expect(errors.single.field, 'aliases');
      expect(errors.single.params, {'max': 20});
    });

    test('a long alias is reported at its index', () {
      // Arrange
      final input = _input(aliases: ['ok', 'y' * 51]);

      // Act
      final errors = ProviderInputValidator.validate(input);

      // Assert
      expect(errors.single.field, 'aliases[1]');
      expect(errors.single.code, 'max_length');
    });
  });

  group('slugOf', () {
    test('joins lowercase words with single hyphens', () {
      // Arrange
      const name = '  Bank  BCA! ';

      // Act
      final slug = ProviderInputValidator.slugOf(name);

      // Assert
      expect(slug, 'bank-bca');
    });

    test('a name without letters or digits has no slug', () {
      // Arrange
      const name = '***';

      // Act
      final slug = ProviderInputValidator.slugOf(name);

      // Assert
      expect(slug, isEmpty);
    });
  });
}
