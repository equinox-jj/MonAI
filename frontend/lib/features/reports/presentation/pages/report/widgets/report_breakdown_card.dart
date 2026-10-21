import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/reports/domain/logic/report_change.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';

class ReportBreakdownCard extends StatelessWidget {
  const ReportBreakdownCard({super.key});

  static const _donutSize = 200.0;
  static const _donutStroke = 22.0;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReportBloc, ReportState, MonthlyReport?>(
      selector: (state) => state.report,
      builder: (context, report) {
        if (report == null) return const SizedBox.shrink();
        final l10n = context.l10n;
        final t = context.textTheme;
        final c = context.colors;
        final monthName = MonthFormat.monthName(
          report.month,
          context.localeName,
        );
        final rows = report.categories;
        return MonAICard(
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x4,
            children: [
              Text(l10n.reportBreakdownTitle, style: t.titleMedium),
              if (rows.isEmpty)
                MonAIStateMessage(
                  icon: MonAIIcons.receiptLong,
                  title: l10n.reportNoSpendingTitle(monthName),
                  message: l10n.reportNoSpendingBody,
                )
              else ...[
                Center(
                  child: SizedBox.square(
                    dimension: _donutSize,
                    child: Stack(
                      alignment: .center,
                      children: [
                        MonAIDonut(
                          shares: rows.map((r) => r.sharePercent).toList(),
                          colors: rows
                              .map(
                                (r) => CategoryColors.content(
                                  CategoryColors.parse(r.color),
                                  dark: c.isDark,
                                ),
                              )
                              .toList(),
                          stroke: _donutStroke,
                          semanticsLabel: l10n.reportBreakdownDescription(
                            monthName,
                            rows
                                .map(
                                  (r) => l10n.reportBreakdownShareDescription(
                                    r.name,
                                    r.sharePercent.round(),
                                  ),
                                )
                                .join(', '),
                          ),
                        ),
                        ExcludeSemantics(
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                formatRupiahCompact(report.expenseTotal),
                                style: t.headlineSmall?.tabular
                                    .withWeight(.w700)
                                    .copyWith(color: c.textPrimary),
                              ),
                              Text(
                                l10n.reportBreakdownSpentIn(monthName),
                                style: t.bodySmall?.copyWith(
                                  color: c.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: .zero,
                  itemCount: rows.length,
                  itemBuilder: (context, index) => _CategoryRow(
                    row: rows[index],
                    previousMonth: report.previous.month,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.row, required this.previousMonth});

  final CategoryBreakdown row;
  final DateTime previousMonth;

  static const _iconSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final previous = MonthFormat.shortMonthName(
      previousMonth,
      context.localeName,
    );
    final change = ReportChange.of(row.changePercent);
    final (changeText, changeColor) = switch (change) {
      // Spending less is good news.
      ReportChange(trend: .less, :final percent) => (
        l10n.reportChangeLess(percent, previous),
        c.successText,
      ),
      ReportChange(trend: .more, :final percent) => (
        l10n.reportChangeMore(percent, previous),
        c.errorText,
      ),
      ReportChange(trend: .same) => (
        l10n.reportChangeSame(previous),
        c.textTertiary,
      ),
      null => (null, c.textTertiary),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: Padding(
        padding: const .symmetric(vertical: MonAISpacing.x2_5),
        child: Row(
          spacing: MonAISpacing.x3,
          children: [
            MonAICategoryIcon(
              icon: categoryIcon(row.icon),
              color: CategoryColors.parse(row.color),
              size: _iconSize,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: MonAISpacing.x1,
                children: [
                  Row(
                    spacing: MonAISpacing.x2,
                    children: [
                      Expanded(
                        child: Text(
                          row.name,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: t.labelLarge?.copyWith(color: c.textPrimary),
                        ),
                      ),
                      Text(
                        formatRupiah(row.amount),
                        style: t.labelLarge?.tabular.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: MonAISpacing.x2,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.reportBreakdownShare(row.sharePercent.round()),
                          style: t.bodySmall?.copyWith(color: c.textTertiary),
                        ),
                      ),
                      if (changeText != null)
                        Text(
                          changeText,
                          style: t.bodySmall?.tabular
                              .withWeight(.w600)
                              .copyWith(color: changeColor),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
