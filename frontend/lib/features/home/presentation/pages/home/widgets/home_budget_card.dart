import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

typedef _BudgetSection = ({
  HomeBudgetDisplay display,
  Budget? budget,
  DateTime? month,
  int daysLeft,
});

/// The month's budget progress, or the prompt to set one. Opens Budget.
///
/// Tablets give it a taller card with a "Change budget" link.
class HomeBudgetCard extends StatelessWidget {
  const HomeBudgetCard({
    required this.onOpenBudget,
    required this.widthClass,
    super.key,
  });

  final VoidCallback onOpenBudget;
  final MonAIWidthClass widthClass;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, _BudgetSection>(
      selector: (state) => (
        display: state.budgetDisplay,
        budget: state.dashboard?.budget,
        month: state.dashboard?.month,
        daysLeft: state.dashboard?.daysLeftInMonth ?? 0,
      ),
      builder: (context, section) {
        final l10n = context.l10n;
        final month = section.month;
        final monthName = month == null
            ? ''
            : MonthFormat.monthName(month, context.localeName);
        return switch ((section.display, section.budget)) {
          (.progress, final budget?) => _BudgetProgress(
            budget: budget,
            title: l10n.homeBudgetTitle(monthName),
            daysLeft: section.daysLeft,
            tablet: widthClass != .compact,
            onTap: onOpenBudget,
          ),
          (.prompt, _) || (.progress, null) => MonAIBudgetPromptCard(
            title: l10n.homeBudgetEmptyTitle(monthName),
            body: l10n.homeBudgetEmptyBody,
            actionLabel: l10n.homeBudgetSet,
            onTap: onOpenBudget,
          ),
          (.hidden, _) => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _BudgetProgress extends StatelessWidget {
  const _BudgetProgress({
    required this.budget,
    required this.title,
    required this.daysLeft,
    required this.tablet,
    required this.onTap,
  });

  final Budget budget;
  final String title;
  final int daysLeft;
  final bool tablet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final statusColor = budget.status.color(c);
    // Rounded down, so the bar never reads 100% before the limit is reached.
    final percent = budget.progressPercent.floor();
    final days = daysLeft == 0
        ? l10n.homeBudgetLastDay
        : l10n.homeBudgetDaysLeft(daysLeft);
    final remaining = budget.remaining < 0
        ? l10n.homeBudgetOver(formatRupiah(budget.remaining.abs()))
        : l10n.homeBudgetLeft(formatRupiah(budget.remaining));
    final progress = l10n.homeBudgetProgress(
      formatRupiah(budget.spent),
      formatRupiah(budget.limitAmount),
    );
    final percentText = Text(
      l10n.homePercent(percent),
      style: context.textStyles.amountMedium.copyWith(
        color: statusColor,
        fontSize: tablet ? 24 : null,
      ),
    );
    final bar = MonAIProgressBar(
      progress: budget.progressPercent / 100,
      color: statusColor,
    );

    return MonAICard(
      onTap: onTap,
      padding: .all(tablet ? MonAISpacing.x5 : MonAISpacing.cardPadding),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: tablet ? MonAISpacing.x3_5 : MonAISpacing.x3,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(title, style: t.titleMedium),
                    if (!tablet)
                      Text(
                        days,
                        style: t.bodySmall?.copyWith(color: c.textTertiary),
                      ),
                  ],
                ),
              ),
              percentText,
            ],
          ),
          bar,
          if (tablet) ...[
            Text(
              progress,
              style: t.bodyMedium?.tabular.copyWith(color: c.textSecondary),
            ),
            MonAIBudgetRemaining(
              text: '$remaining · $days',
              status: budget.status,
            ),
            Align(
              alignment: .centerLeft,
              child: MonAITextLink(
                label: l10n.homeBudgetChange,
                onPressed: onTap,
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: Text(
                    progress,
                    style: context.textStyles.bodyCompact.tabular.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ),
                MonAIBudgetRemaining(text: remaining, status: budget.status),
              ],
            ),
        ],
      ),
    );
  }
}
