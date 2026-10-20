import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

/// A field of a quick-add draft under review.
enum QuickAddField {
  amount(TransactionInputValidator.amountField),
  category(TransactionInputValidator.categoryField),
  wallet(TransactionInputValidator.walletField),
  toWallet(TransactionInputValidator.toWalletField),
  date(TransactionInputValidator.dateField),
  note(TransactionInputValidator.noteField);

  const QuickAddField(this.apiField);

  /// The field's name in the API and in its `FieldError`s.
  final String apiField;
}
