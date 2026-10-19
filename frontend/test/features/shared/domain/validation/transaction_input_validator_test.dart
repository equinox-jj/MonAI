import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

void main() {
  final today = DateTime(2026, 10, 19, 15, 30);

  TransactionInput expense({
    int amount = 10000,
    String? walletId = 'w1',
    String? categoryId = 'c1',
    DateTime? date,
    String? note,
    String? merchant,
  }) => TransactionInput(
    type: TransactionType.expense,
    amount: amount,
    walletId: walletId,
    categoryId: categoryId,
    date: date ?? DateTime(2026, 10, 19),
    note: note,
    merchant: merchant,
  );

  List<(String, String)> errorsOf(TransactionInput input) =>
      TransactionInputValidator.validate(
        input,
        today: today,
      ).map((e) => (e.field, e.code)).toList();

  group('normalized', () {
    test('trims the note and merchant, blank becoming null', () {
      // Arrange
      final input = expense(note: '  Kopi  ', merchant: '   ');

      // Act
      final result = input.normalized;

      // Assert
      expect(result.note, 'Kopi');
      expect(result.merchant, isNull);
    });

    test('drops a destination wallet unless it is a transfer', () {
      // Arrange
      final input = expense().copyWith(toWalletId: 'w2');

      // Act
      final result = input.normalized;

      // Assert
      expect(result.toWalletId, isNull);
      expect(result.categoryId, 'c1');
    });

    test('drops the category of a transfer and the time of day', () {
      // Arrange
      final input = expense(date: DateTime(2026, 10, 2, 13, 45))
          .copyWith(type: TransactionType.transfer, toWalletId: 'w2');

      // Act
      final result = input.normalized;

      // Assert
      expect(result.categoryId, isNull);
      expect(result.toWalletId, 'w2');
      expect(result.date, DateTime(2026, 10, 2));
    });
  });

  group('validate', () {
    test('a complete expense dated today is valid', () {
      // Arrange
      final input = expense();

      // Act
      final errors = errorsOf(input);

      // Assert
      expect(errors, isEmpty);
    });

    test('the amount must be between 1 and the maximum', () {
      // Arrange
      final zero = expense(amount: 0);
      final tooLarge = expense(amount: TransactionInputValidator.amountMax + 1);

      // Act
      final zeroErrors = errorsOf(zero);
      final tooLargeErrors = errorsOf(tooLarge);

      // Assert
      expect(zeroErrors, [('amount', 'min')]);
      expect(tooLargeErrors, [('amount', 'max')]);
    });

    test('an expense needs a wallet and a category', () {
      // Arrange
      final input = expense(walletId: null, categoryId: null);

      // Act
      final errors = errorsOf(input);

      // Assert
      expect(errors, [('wallet_id', 'required'), ('category_id', 'required')]);
    });

    test('a transfer needs a different destination wallet', () {
      // Arrange
      final base = expense(categoryId: null)
          .copyWith(type: TransactionType.transfer);

      // Act
      final missing = errorsOf(base);
      final same = errorsOf(base.copyWith(toWalletId: 'w1'));

      // Assert
      expect(missing, [('to_wallet_id', 'required')]);
      expect(same, [('to_wallet_id', 'not_equal')]);
    });

    test('the date cannot be after today', () {
      // Arrange
      final input = expense(date: DateTime(2026, 10, 20));

      // Act
      final errors = errorsOf(input);

      // Assert
      expect(errors, [('date', 'future_date')]);
    });

    test('the note and merchant have a maximum length', () {
      // Arrange
      final input = expense(note: 'a' * 201, merchant: 'b' * 101);

      // Act
      final errors = TransactionInputValidator.validate(input, today: today);

      // Assert
      expect(errors.map((e) => (e.field, e.code)), [
        ('note', 'max_length'),
        ('merchant', 'max_length'),
      ]);
      expect(errors.map((e) => e.params), [
        {'max': 200},
        {'max': 100},
      ]);
    });
  });
}
