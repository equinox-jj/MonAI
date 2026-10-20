import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

/// A year of months with what was spent in each, where cached; months after
/// [currentMonth] can't be picked. "Show October 2026" sends the pick to
/// [onApply] and closes. Show it with [showMonAIBottomSheet].
class TransactionMonthPickerSheet extends StatefulWidget {
  const TransactionMonthPickerSheet({
    required this.selected,
    required this.currentMonth,
    required this.totals,
    required this.onYearShown,
    required this.onApply,
    super.key,
  });

  /// The first of the month shown now.
  final DateTime selected;
  final DateTime currentMonth;

  /// Spent per cached month of the year shown, keyed by the first of the
  /// month.
  final Map<DateTime, int> totals;

  /// A year page is shown, so its totals are needed.
  final ValueChanged<int> onYearShown;
  final ValueChanged<DateTime> onApply;

  @override
  State<TransactionMonthPickerSheet> createState() =>
      _TransactionMonthPickerSheetState();
}

typedef _Draft = ({int year, DateTime selected});

class _TransactionMonthPickerSheetState
    extends State<TransactionMonthPickerSheet> {
  late final _draft = ValueNotifier<_Draft>((
    year: widget.selected.year,
    selected: widget.selected,
  ));

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _showYear(int year) {
    _draft.value = (year: year, selected: _draft.value.selected);
    widget.onYearShown(year);
  }

  void _pick(DateTime month) =>
      _draft.value = (year: _draft.value.year, selected: month);

  void _apply() {
    widget.onApply(_draft.value.selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return ValueListenableBuilder(
      valueListenable: _draft,
      builder: (context, draft, _) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x4,
        children: [
          _YearSwitcher(
            year: draft.year,
            canShowNext: draft.year < widget.currentMonth.year,
            onShowYear: _showYear,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: DateTime.monthsPerYear,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: MonAISpacing.x2,
              crossAxisSpacing: MonAISpacing.x2,
              mainAxisExtent: MonAISizes.pickerOption,
            ),
            itemBuilder: (context, index) {
              final month = DateTime(draft.year, index + 1);
              return _MonthCell(
                month: month,
                spent: widget.totals[month],
                selected: month == draft.selected,
                enabled: !month.isAfter(widget.currentMonth),
                onPick: _pick,
              );
            },
          ),
          MonAIButton(
            label: l10n.monthPickerShow(
              TransactionDates.monthYear(draft.selected, locale),
            ),
            onPressed: _apply,
            expand: true,
          ),
        ],
      ),
    );
  }
}

class _YearSwitcher extends StatelessWidget {
  const _YearSwitcher({
    required this.year,
    required this.canShowNext,
    required this.onShowYear,
  });

  final int year;
  final bool canShowNext;
  final ValueChanged<int> onShowYear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceSunken,
        borderRadius: MonAIRadius.fullAll,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          MonAIIconButton(
            icon: MonAIIcons.chevronLeft,
            tooltip: l10n.monthPickerPreviousYear,
            onPressed: () => onShowYear(year - 1),
          ),
          Text('$year', style: context.textTheme.titleMedium),
          MonAIIconButton(
            icon: MonAIIcons.chevronRight,
            tooltip: l10n.monthPickerNextYear,
            onPressed: canShowNext ? () => onShowYear(year + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.month,
    required this.spent,
    required this.selected,
    required this.enabled,
    required this.onPick,
  });

  final DateTime month;
  final int? spent;
  final bool selected;
  final bool enabled;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final foreground = selected
        ? c.onPrimary
        : enabled
        ? c.textPrimary
        : c.textDisabled;
    final caption = switch ((enabled, spent)) {
      (false, _) => '',
      (true, final spent?) => formatRupiahCompact(spent),
      (true, null) => context.l10n.monthPickerNoData,
    };
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: Material(
        color: selected ? c.primary : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdlAll,
          side: selected ? BorderSide.none : BorderSide(color: c.border),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: enabled ? () => onPick(month) : null,
          child: Column(
            mainAxisAlignment: .center,
            spacing: MonAISpacing.x0_5,
            children: [
              Text(
                MonthFormat.shortMonthName(month, context.localeName),
                style: t.labelLarge?.copyWith(color: foreground),
              ),
              Text(
                caption,
                style: t.labelSmall?.copyWith(
                  color: selected ? c.onPrimary : c.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
