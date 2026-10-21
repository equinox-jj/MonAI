import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

extension TransactionFieldErrorText on FieldError {
  /// The message under the field, from the device's checks or the server's.
  String text(AppLocalizations l10n) => switch ((field, code)) {
    (TransactionInputValidator.amountField, 'max') =>
      l10n.transactionErrorAmountMax(
        formatRupiah(TransactionInputValidator.amountMax),
      ),
    (TransactionInputValidator.amountField, _) =>
      l10n.transactionErrorAmountRequired,
    (TransactionInputValidator.walletField, _) =>
      l10n.transactionErrorWalletRequired,
    (TransactionInputValidator.toWalletField, 'not_equal') =>
      l10n.transactionErrorSameWallet,
    (TransactionInputValidator.toWalletField, _) =>
      l10n.transactionErrorToWalletRequired,
    (TransactionInputValidator.categoryField, _) =>
      l10n.transactionErrorCategoryRequired,
    (TransactionInputValidator.dateField, _) => l10n.transactionErrorFutureDate,
    (_, 'max_length') => l10n.transactionErrorTooLong(
      (params['max'] as num?)?.toInt() ?? 0,
    ),
    _ => message,
  };
}
