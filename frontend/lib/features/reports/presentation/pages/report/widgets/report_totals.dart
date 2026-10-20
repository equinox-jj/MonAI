import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/reports/domain/logic/report_change.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';

typedef _Totals = ({MonthlyReport report, ReportChange? change});

/// Income and expense side by side, then the net on the gradient card with
/// how spending compares with the month before.
class ReportTotals extends StatelessWidget {
  const ReportTotals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReportBloc, ReportState, _Totals?>(
      selector: (state) => switch (state.report) {
        final report? => (report: report, change: state.expenseChange),
        null => null,
      },
      builder: (context, totals) {
        if (totals == null) return const SizedBox.shrink();
        final l10n = context.l10n;
        final c = context.colors;
        final report = totals.report;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            Row(
              spacing: MonAISpacing.x2,
              children: [
                Expanded(
                  child: _TotalTile(
                    label: l10n.reportIncome,
                    icon: MonAIIcons.southWest,
                    amount: formatRupiahSigned(
                      report.incomeTotal,
                      negative: false,
                    ),
                    color: c.income,
                    container: c.incomeContainer,
                  ),
                ),
                Expanded(
                  child: _TotalTile(
                    label: l10n.reportExpense,
                    icon: MonAIIcons.northEast,
                    amount: formatRupiahSigned(
                      report.expenseTotal,
                      negative: true,
                    ),
                    color: c.expense,
                    container: c.expenseContainer,
                  ),
                ),
              ],
            ),
            _NetCard(
              net: report.net,
              previousMonth: report.previous.month,
              change: totals.change,
            ),
          ],
        );
      },
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.icon,
    required this.amount,
    required this.color,
    required this.container,
  });

  final String label;
  final MonAIIconData icon;
  final String amount;
  final Color color;
  final Color container;

  static const _iconCircle = 24.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return MonAICard(
      padding: const .all(MonAISpacing.x3_5),
      child: Column(
        crossAxisAlignment: .start,
        spacing: MonAISpacing.x1_5,
        children: [
          Row(
            spacing: MonAISpacing.x1_5,
            children: [
              Container(
                width: _iconCircle,
                height: _iconCircle,
                alignment: .center,
                decoration: BoxDecoration(color: container, shape: .circle),
                child: MonAIIcon(icon, size: MonAISizes.iconSm, color: color),
              ),
              Text(label, style: t.bodySmall?.copyWith(color: c.textSecondary)),
            ],
          ),
          FittedBox(
            fit: .scaleDown,
            alignment: .centerLeft,
            child: Text(
              amount,
              style: t.titleLarge?.tabular
                  .withWeight(.w700)
                  .copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetCard extends StatelessWidget {
  const _NetCard({
    required this.net,
    required this.previousMonth,
    required this.change,
  });

  final int net;
  final DateTime previousMonth;
  final ReportChange? change;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final previous = MonthFormat.shortMonthName(
      previousMonth,
      context.localeName,
    );
    final changeText = switch (change) {
      ReportChange(trend: .less, :final percent) => l10n.reportSpentLess(
        percent,
        previous,
      ),
      ReportChange(trend: .more, :final percent) => l10n.reportSpentMore(
        percent,
        previous,
      ),
      ReportChange(trend: .same) => l10n.reportSpentSame(previous),
      null => null,
    };
    return MonAIGradientCard(
      borderRadius: MonAIRadius.lgAll,
      padding: const .symmetric(
        horizontal: MonAISpacing.x4,
        vertical: MonAISpacing.x3_5,
      ),
      elevated: false,
      decorated: false,
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.reportNet,
                  style: t.bodySmall?.copyWith(color: c.onGradientMuted),
                ),
                FittedBox(
                  fit: .scaleDown,
                  alignment: .centerLeft,
                  child: Text(
                    formatRupiahSigned(net, negative: net < 0),
                    style: t.headlineMedium?.tabular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (changeText != null)
            Flexible(
              child: MonAIPill(
                text: changeText,
                containerColor: c.highlight,
                contentColor: c.onHighlight,
              ),
            ),
        ],
      ),
    );
  }
}
