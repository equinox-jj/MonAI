import 'package:intl/intl.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_wallet_avatar.dart';

/// `Today, 10 Oct`, `Yesterday, 9 Oct`, else `Thu, 8 Oct 2026`.
String receiptDateText(
  DateTime day,
  DateTime today,
  AppLocalizations l10n,
  String locale,
) {
  final short = DateFormat('d MMM', locale).format(day);
  if (day == today) return l10n.transactionFormTodayDate(short);
  if (day == DateTime(today.year, today.month, today.day - 1)) {
    return l10n.transactionFormYesterdayDate(short);
  }
  return DateFormat('EEE, d MMM y', locale).format(day);
}

/// The text of the review's [MonAIDatePickerSheet], up to [today].
MonAIDatePickerLabels receiptDatePickerLabels(
  AppLocalizations l10n, {
  required DateTime today,
  required String locale,
}) => MonAIDatePickerLabels(
  title: l10n.transactionFormDateTitle,
  dateText: (date) => receiptDateText(date, today, l10n, locale),
  today: l10n.transactionFormToday,
  yesterday: l10n.transactionFormYesterday,
  dayUnavailable: l10n.transactionFormDayUnavailable,
  futureNote: l10n.transactionFormFutureNote,
  cancel: l10n.transactionFormCancel,
  set: l10n.transactionFormSetDate,
);

extension ReceiptCategoryOption on Category {
  /// This category in [MonAICategoryPickerSheet].
  MonAICategoryOption get pickerOption => MonAICategoryOption(
    id: id,
    name: name,
    icon: categoryIcon(icon),
    color: CategoryColors.parse(color),
  );
}

extension ReceiptWalletOption on Wallet {
  /// This wallet with its balance in [MonAIRadioPickerSheet].
  MonAIRadioPickerOption pickerOption(AppLocalizations l10n) =>
      MonAIRadioPickerOption(
        id: id,
        title: name,
        subtitle: formatRupiah(currentBalance),
        tag: isDefault ? l10n.transactionFormDefault : null,
        leading: ReceiptWalletAvatar(wallet: this),
      );
}
