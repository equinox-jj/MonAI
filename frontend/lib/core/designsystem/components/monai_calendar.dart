import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/components/monai_button.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// A month of days on the [shownMonth] page, with [selected] filled and
/// [today] outlined. Days after [today] can't be picked, and it only pages
/// back from the current month. Draws only the weeks the month needs.
class MonAICalendar extends StatelessWidget {
  /// Creates a calendar.
  const MonAICalendar({
    required this.selected,
    required this.shownMonth,
    required this.today,
    required this.onSelect,
    required this.onShowMonth,
    required this.dayUnavailableLabel,
    super.key,
  });

  /// The day grid, for tests.
  static const daysKey = ValueKey('monai-calendar-days');

  /// The picked day.
  final DateTime selected;

  /// Any day in the month on screen.
  final DateTime shownMonth;

  /// The last day that can be picked.
  final DateTime today;

  /// Called with the tapped day.
  final ValueChanged<DateTime> onSelect;

  /// Called with the first of the month to page to.
  final ValueChanged<DateTime> onShowMonth;

  /// The screen-reader label of a future day, from its full date.
  final String Function(String date) dayUnavailableLabel;

  @override
  Widget build(BuildContext context) {
    final l = MaterialLocalizations.of(context);
    final month = DateTime(shownMonth.year, shownMonth.month);
    final previous = DateTime(month.year, month.month - 1);
    final next = DateTime(month.year, month.month + 1);
    final firstDay = l.firstDayOfWeekIndex;
    // DateTime.weekday is 1 (Mon)..7 (Sun); the localizations count from Sun.
    final leading = (month.weekday % 7 - firstDay + 7) % 7;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            MonAIIconButton(
              icon: MonAIIcons.chevronLeft,
              tooltip: l.formatMonthYear(previous),
              onPressed: () => onShowMonth(previous),
              color: context.colors.textSecondary,
            ),
            Expanded(
              child: Text(
                l.formatMonthYear(month),
                style: context.textTheme.titleSmall?.withWeight(.w600),
                textAlign: .center,
              ),
            ),
            MonAIIconButton(
              icon: MonAIIcons.chevronRight,
              tooltip: l.formatMonthYear(next),
              onPressed: next.isAfter(today) ? null : () => onShowMonth(next),
              color: context.colors.textSecondary,
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: DateTime.daysPerWeek,
            mainAxisExtent: _weekdayRow,
          ),
          itemCount: DateTime.daysPerWeek,
          itemBuilder: (context, i) => Center(
            child: ExcludeSemantics(
              child: Text(
                l.narrowWeekdays[(firstDay + i) % DateTime.daysPerWeek],
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ),
          ),
        ),
        GridView.builder(
          key: daysKey,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: DateTime.daysPerWeek,
            mainAxisExtent: MonAISizes.touchTarget,
          ),
          itemCount:
              leading + DateUtils.getDaysInMonth(month.year, month.month),
          itemBuilder: (context, i) {
            if (i < leading) return const SizedBox.shrink();
            final date = DateTime(month.year, month.month, i - leading + 1);
            return Center(
              child: _Day(
                date: date,
                selected: DateUtils.isSameDay(date, selected),
                isToday: DateUtils.isSameDay(date, today),
                enabled: !date.isAfter(today),
                onTap: () => onSelect(date),
                dayUnavailableLabel: dayUnavailableLabel,
              ),
            );
          },
        ),
      ],
    );
  }

  static const double _weekdayRow = 28;
}

class _Day extends StatelessWidget {
  const _Day({
    required this.date,
    required this.selected,
    required this.isToday,
    required this.enabled,
    required this.onTap,
    required this.dayUnavailableLabel,
  });

  final DateTime date;
  final bool selected;
  final bool isToday;
  final bool enabled;
  final VoidCallback onTap;
  final String Function(String date) dayUnavailableLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final full = MaterialLocalizations.of(context).formatFullDate(date);
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: enabled ? full : dayUnavailableLabel(full),
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: MonAISizes.avatarMedium,
        child: Material(
          color: selected ? c.primary : Colors.transparent,
          shape: CircleBorder(
            side: isToday && !selected
                ? BorderSide(color: c.accent)
                : BorderSide.none,
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: Center(
              child: Text(
                '${date.day}',
                style: context.textTheme.bodyMedium
                    ?.withWeight(selected || isToday ? .w700 : .w500)
                    .tabular
                    .copyWith(
                      color: selected
                          ? c.onPrimary
                          : enabled
                          ? c.textPrimary
                          : c.textDisabled,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
