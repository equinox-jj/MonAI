import 'package:monai/core/database/daos/monthly_report_with_categories.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/monthly_report_response.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';

extension MonthlyReportDataMapper on MonthlyReportData {
  /// The report row and its breakdown rows, in the server's order.
  MonthlyReportWithCategories toRows() {
    final reportMonth = parseApiMonth(month);
    final previousData = requireField(previous);
    final breakdown = categories ?? const [];
    return (
      report: MonthlyReportRow(
        month: reportMonth,
        incomeTotal: requireField(incomeTotal),
        expenseTotal: requireField(expenseTotal),
        net: requireField(net),
        previousMonth: parseApiMonth(previousData.month),
        previousIncomeTotal: requireField(previousData.incomeTotal),
        previousExpenseTotal: requireField(previousData.expenseTotal),
        expenseChangePercent: expenseChangePercent,
      ),
      categories: [
        for (final (position, item) in breakdown.indexed)
          ReportCategoryRow(
            month: reportMonth,
            categoryId: requireField(item.categoryId),
            position: position,
            name: requireField(item.name),
            icon: item.icon,
            color: item.color,
            amount: requireField(item.amount),
            sharePercent: requireField(item.sharePercent),
            previousAmount: requireField(item.previousAmount),
            changePercent: item.changePercent,
          ),
      ],
    );
  }
}

extension MonthlyReportRowsMapper on MonthlyReportWithCategories {
  MonthlyReport toEntity() => MonthlyReport(
    month: report.month,
    incomeTotal: report.incomeTotal,
    expenseTotal: report.expenseTotal,
    net: report.net,
    previous: PreviousMonthTotals(
      month: report.previousMonth,
      incomeTotal: report.previousIncomeTotal,
      expenseTotal: report.previousExpenseTotal,
    ),
    expenseChangePercent: report.expenseChangePercent,
    categories: categories
        .map(
          (row) => CategoryBreakdown(
            categoryId: row.categoryId,
            name: row.name,
            icon: row.icon,
            color: row.color,
            amount: row.amount,
            sharePercent: row.sharePercent,
            previousAmount: row.previousAmount,
            changePercent: row.changePercent,
          ),
        )
        .toList(),
  );
}
