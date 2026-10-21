import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_wallet_avatar.dart';

extension CategoryPickerOption on Category {
  /// This category in [MonAICategoryPickerSheet].
  MonAICategoryOption get pickerOption => MonAICategoryOption(
    id: id,
    name: name,
    icon: categoryIcon(icon),
    color: CategoryColors.parse(color),
  );
}

extension WalletPickerOption on Wallet {
  /// This wallet with its balance in [MonAIRadioPickerSheet].
  MonAIRadioPickerOption pickerOption(AppLocalizations l10n) =>
      MonAIRadioPickerOption(
        id: id,
        title: name,
        subtitle: formatRupiah(currentBalance),
        tag: isDefault ? l10n.transactionFormDefault : null,
        leading: TransactionWalletAvatar(wallet: this),
      );
}

/// The text of the form's [MonAIDatePickerSheet], up to [today].
MonAIDatePickerLabels transactionDatePickerLabels(
  AppLocalizations l10n, {
  required DateTime today,
  required String locale,
}) => MonAIDatePickerLabels(
  title: l10n.transactionFormDateTitle,
  dateText: (date) => TransactionDates.field(date, today, l10n, locale),
  today: l10n.transactionFormToday,
  yesterday: l10n.transactionFormYesterday,
  dayUnavailable: l10n.transactionFormDayUnavailable,
  futureNote: l10n.transactionFormFutureNote,
  cancel: l10n.transactionFormCancel,
  set: l10n.transactionFormSetDate,
);
