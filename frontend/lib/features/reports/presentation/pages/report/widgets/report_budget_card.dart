import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

/// The month's budget progress, or the prompt to set one. Opens Budget.
class ReportBudgetCard extends StatelessWidget {
  const ReportBudgetCard({required this.onOpenBudget, super.key});

  final VoidCallback onOpenBudget;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ReportBloc,
      ReportState,
      ({bool loaded, Budget? budget, DateTime month})
    >(
      selector: (state) => (
        loaded: state.report != null,
        budget: state.budget,
        month: state.month,
      ),
      builder: (context, section) {
        if (!section.loaded) return const SizedBox.shrink();
        final l10n = context.l10n;
        return switch (section.budget) {
          final budget? => _BudgetProgress(budget: budget, onTap: onOpenBudget),
          null => MonAIBudgetPromptCard(
            title: l10n.reportBudgetEmptyTitle(
              MonthFormat.monthName(section.month, context.localeName),
            ),
            body: l10n.reportBudgetEmptyBody,
            actionLabel: l10n.reportBudgetSet,
            onTap: onOpenBudget,
          ),
        };
      },
    );
  }
}

class _BudgetProgress extends StatelessWidget {
  const _BudgetProgress({required this.budget, required this.onTap});

  final Budget budget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final remaining = budget.remaining;
    return MonAICard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x2_5,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.reportBudgetTitle, style: t.titleMedium),
              ),
              Text(
                l10n.reportBudgetChange,
                style: t.labelLarge?.copyWith(color: c.accent),
              ),
            ],
          ),
          MonAIProgressBar(
            progress: budget.progressPercent / 100,
            color: budget.status.color(c),
          ),
          Row(
            spacing: MonAISpacing.x2,
            children: [
              Expanded(
                child: Text(
                  l10n.reportBudgetProgress(
                    budget.progressPercent.floor(),
                    formatRupiah(budget.limitAmount),
                  ),
                  style: t.bodyMedium?.tabular.copyWith(color: c.textSecondary),
                ),
              ),
              MonAIBudgetRemaining(
                text: remaining < 0
                    ? l10n.reportBudgetOver(formatRupiah(-remaining))
                    : l10n.reportBudgetLeft(formatRupiah(remaining)),
                status: budget.status,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
