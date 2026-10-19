import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/budget_response.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

extension BudgetDataMapper on BudgetData {
  BudgetRow toRow() => BudgetRow(
    month: parseApiMonth(month),
    limitAmount: requireField(limitAmount),
    spent: requireField(spent),
    remaining: requireField(remaining),
    progressPercent: requireField(progressPercent),
    status: parseBudgetStatus(status),
  );
}

extension BudgetRowMapper on BudgetRow {
  Budget toEntity() => Budget(
    month: month,
    limitAmount: limitAmount,
    spent: spent,
    remaining: remaining,
    progressPercent: progressPercent,
    status: status,
  );
}
