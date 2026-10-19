import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';

void main() {
  List<(String, String)> errorsOf(WalletInput input) =>
      WalletInputValidator.validate(input)
          .map((e) => (e.field, e.code))
          .toList();

  test('normalized trims the name', () {
    // Arrange
    const input = WalletInput(name: '  Cash  ');

    // Act
    final result = input.normalized;

    // Assert
    expect(result.name, 'Cash');
  });

  test('a complete custom wallet is valid', () {
    // Arrange
    const input = WalletInput(
      name: 'Cash',
      type: WalletType.cash,
      initialBalance: 5000,
      color: '#1A2b3C',
    );

    // Act
    final errors = errorsOf(input);

    // Assert
    expect(errors, isEmpty);
  });

  test('a custom wallet needs a name and a type', () {
    // Arrange
    const input = WalletInput(name: '');

    // Act
    final errors = errorsOf(input);

    // Assert
    expect(errors, [('name', 'required'), ('type', 'required')]);
  });

  test('a provider wallet may leave its name and type to the provider', () {
    // Arrange
    const input = WalletInput(name: '', providerId: 'p1');

    // Act
    final errors = errorsOf(input);

    // Assert
    expect(errors, isEmpty);
  });

  test('the name has a maximum length', () {
    // Arrange
    final input = WalletInput(name: 'a' * 31, type: WalletType.cash);

    // Act
    final errors = errorsOf(input);

    // Assert
    expect(errors, [('name', 'max_length')]);
  });

  test('the opening balance must be within range', () {
    // Arrange
    const negative = WalletInput(
      name: 'Cash',
      type: WalletType.cash,
      initialBalance: -1,
    );
    const tooLarge = WalletInput(
      name: 'Cash',
      type: WalletType.cash,
      initialBalance: WalletInputValidator.initialBalanceMax + 1,
    );

    // Act
    final negativeErrors = errorsOf(negative);
    final tooLargeErrors = errorsOf(tooLarge);

    // Assert
    expect(negativeErrors, [('initial_balance', 'min')]);
    expect(tooLargeErrors, [('initial_balance', 'max')]);
  });

  test('the color must be #RRGGBB', () {
    // Arrange
    const input = WalletInput(
      name: 'Cash',
      type: WalletType.cash,
      color: 'red',
    );

    // Act
    final errors = errorsOf(input);

    // Assert
    expect(errors, [('color', 'invalid_format')]);
  });
}
