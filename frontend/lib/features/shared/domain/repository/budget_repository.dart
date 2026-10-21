import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

abstract class BudgetRepository {
  Stream<Either<Failure, Budget?>> watchBudget(DateTime month);

  /// A month without a budget succeeds with null and clears the cached one.
  Future<Either<Failure, Budget?>> refreshBudget(DateTime month);

  Future<Either<Failure, Budget>> setBudget(DateTime month, int limitAmount);

  /// A month that has none already succeeds.
  Future<Either<Failure, Unit>> deleteBudget(DateTime month);
}
