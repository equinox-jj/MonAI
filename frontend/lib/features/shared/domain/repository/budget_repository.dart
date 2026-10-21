import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

/// Monthly budgets.
abstract class BudgetRepository {
  /// The budget for [month] (the first of the month), or null when none is
  /// set or cached.
  Stream<Either<Failure, Budget?>> watchBudget(DateTime month);

  /// Re-fetches the budget for [month] and gives the cached copy. A month
  /// without a budget succeeds with null and clears the cached one.
  Future<Either<Failure, Budget?>> refreshBudget(DateTime month);

  /// Sets the spending limit of [month] to [limitAmount] rupiah and caches
  /// the result.
  Future<Either<Failure, Budget>> setBudget(DateTime month, int limitAmount);

  /// Removes the budget of [month]. A month that has none already succeeds.
  Future<Either<Failure, Unit>> deleteBudget(DateTime month);
}
