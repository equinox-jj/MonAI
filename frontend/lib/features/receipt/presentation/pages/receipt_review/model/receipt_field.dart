import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

/// A field of the review that the AI may have filled.
enum ReceiptField {
  amount(TransactionInputValidator.amountField),
  merchant(TransactionInputValidator.merchantField),
  category(TransactionInputValidator.categoryField),
  wallet(TransactionInputValidator.walletField),
  date(TransactionInputValidator.dateField),
  note(TransactionInputValidator.noteField);

  const ReceiptField(this.apiField);

  /// The field's name in the API and in its `FieldError`s.
  final String apiField;
}

/// How a field filled from the receipt is shown.
enum FieldMark {
  /// Read with confidence: a sparkle.
  ai,

  /// Read, but unsure: a warning asking the user to check it.
  check,
}
