import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

enum ReceiptField {
  amount(TransactionInputValidator.amountField),
  merchant(TransactionInputValidator.merchantField),
  category(TransactionInputValidator.categoryField),
  wallet(TransactionInputValidator.walletField),
  date(TransactionInputValidator.dateField),
  note(TransactionInputValidator.noteField);

  const ReceiptField(this.apiField);
  final String apiField;
}

enum FieldMark { ai, check }
