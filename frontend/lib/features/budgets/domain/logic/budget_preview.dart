import 'package:monai/core/model/budget_status.dart';

/// Worked out the way the server does, so the budget screen can preview a
/// limit before saving it.
class BudgetPreview {
  const BudgetPreview._({
    required this.limit,
    required this.spent,
    required this.status,
    required this.percent,
  });

  static BudgetPreview? of({required int limit, required int spent}) {
    if (limit <= 0) return null;
    final status = spent > limit
        ? BudgetStatus.exceeded
        : spent * 100 >= limit * 80
        ? BudgetStatus.warning
        : BudgetStatus.ok;
    return BudgetPreview._(
      limit: limit,
      spent: spent,
      status: status,
      percent: spent * 100 ~/ limit,
    );
  }

  final int limit;
  final int spent;
  final BudgetStatus status;

  /// Whole percent of the limit spent, rounded down; can pass 100.
  final int percent;

  int get remaining => limit - spent;

  double get progress => (spent / limit).clamp(0, 1).toDouble();

  @override
  bool operator ==(Object other) =>
      other is BudgetPreview && other.limit == limit && other.spent == spent;

  @override
  int get hashCode => Object.hash(limit, spent);
}
