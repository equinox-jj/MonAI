import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';

extension WalletFieldErrorText on FieldError {
  /// The message under the field, from the device's checks or the server's.
  String text(AppLocalizations l10n) => switch ((field, code)) {
    (WalletInputValidator.nameField, 'max_length') =>
      l10n.walletFormErrorNameTooLong(WalletInputValidator.nameMax),
    (WalletInputValidator.nameField, 'conflict') =>
      l10n.walletFormErrorNameTaken,
    (WalletInputValidator.nameField, _) => l10n.walletFormErrorNameRequired,
    (WalletInputValidator.typeField, _) => l10n.walletFormErrorTypeRequired,
    (WalletInputValidator.initialBalanceField, 'max') =>
      l10n.walletFormErrorBalanceMax(
        formatRupiah(WalletInputValidator.initialBalanceMax),
      ),
    (WalletInputValidator.initialBalanceField, _) =>
      l10n.walletFormErrorBalanceMin,
    _ => message,
  };
}
