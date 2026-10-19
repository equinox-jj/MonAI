import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

/// Monthly budgets.
abstract class BudgetRepository {
  /// The budget for [month] (the first of the month), or null when none is
  /// set or cached.
  Stream<Either<Failure, Budget?>> watchBudget(DateTime month);

  /// Re-fetches the budget for [month] and gives the cached copy. A month
  /// without a budget succeeds with null and clears the cached one.
  Future<Either<Failure, Budget?>> refreshBudget(DateTime month);
}
