import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

enum QuickAddField {
  amount(TransactionInputValidator.amountField),
  category(TransactionInputValidator.categoryField),
  wallet(TransactionInputValidator.walletField),
  toWallet(TransactionInputValidator.toWalletField),
  date(TransactionInputValidator.dateField),
  note(TransactionInputValidator.noteField);

  const QuickAddField(this.apiField);
  final String apiField;
}
