import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

/// A calendar up to [today], with Today and Yesterday shortcuts; "Set date"
/// sends the pick to [onPick] and closes. Show it with
/// [showMonAIBottomSheet].
class TransactionDatePickerSheet extends StatefulWidget {
  const TransactionDatePickerSheet({
    required this.selected,
    required this.today,
    required this.onPick,
    super.key,
  });

  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onPick;

  @override
  State<TransactionDatePickerSheet> createState() =>
      _TransactionDatePickerSheetState();
}

class _TransactionDatePickerSheetState
    extends State<TransactionDatePickerSheet> {
  late final _today = DateUtils.dateOnly(widget.today);
  late final _selected = ValueNotifier<DateTime>(
    DateUtils.dateOnly(widget.selected),
  );
  late final _shownMonth = ValueNotifier<DateTime>(monthOf(widget.selected));

  @override
  void dispose() {
    _selected.dispose();
    _shownMonth.dispose();
    super.dispose();
  }

  void _pick(DateTime date) => _selected.value = DateUtils.dateOnly(date);

  /// A shortcut also pages the calendar to its month.
  void _jumpTo(DateTime date) {
    _pick(date);
    _shownMonth.value = monthOf(date);
  }

  void _pickToday() => _jumpTo(_today);

  void _pickYesterday() =>
      _jumpTo(DateTime(_today.year, _today.month, _today.day - 1));

  void _showMonth(DateTime month) => _shownMonth.value = month;

  void _cancel() => Navigator.pop(context);

  void _set() {
    widget.onPick(_selected.value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return ValueListenableBuilder(
      valueListenable: _selected,
      builder: (context, selected, _) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x3_5,
        children: [
          Column(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x0_5,
            children: [
              Text(
                l10n.transactionFormDateTitle,
                style: context.textTheme.labelMedium?.copyWith(
                  color: c.textSecondary,
                ),
              ),
              Text(
                TransactionDates.field(
                  selected,
                  widget.today,
                  l10n,
                  context.localeName,
                ),
                style: context.textTheme.headlineSmall,
              ),
            ],
          ),
          Row(
            spacing: MonAISpacing.x2,
            children: [
              MonAIButton(
                label: l10n.transactionFormToday,
                onPressed: _pickToday,
                variant: .outlined,
                size: .small,
              ),
              MonAIButton(
                label: l10n.transactionFormYesterday,
                onPressed: _pickYesterday,
                variant: .outlined,
                size: .small,
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: _shownMonth,
            builder: (context, shownMonth, _) => MonAICalendar(
              selected: selected,
              shownMonth: shownMonth,
              today: _today,
              onSelect: _pick,
              onShowMonth: _showMonth,
              dayUnavailableLabel: l10n.transactionFormDayUnavailable,
            ),
          ),
          Row(
            spacing: MonAISpacing.x1_5,
            children: [
              MonAIIcon(
                MonAIIcons.block,
                size: MonAISizes.iconSm,
                color: c.textTertiary,
              ),
              Text(
                l10n.transactionFormFutureNote,
                style: context.textTheme.bodySmall?.copyWith(
                  color: c.textTertiary,
                ),
              ),
            ],
          ),
          MonAISheetButtons(
            secondaryLabel: l10n.transactionFormCancel,
            onSecondary: _cancel,
            primaryLabel: l10n.transactionFormSetDate,
            onPrimary: _set,
          ),
        ],
      ),
    );
  }
}
