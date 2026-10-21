import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/budget_status.dart';

part 'budget.freezed.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    /// The first of the month.
    required DateTime month,
    required int limitAmount,
    required int spent,
    required int remaining,
    required double progressPercent,
    required BudgetStatus status,
  }) = _Budget;
}
