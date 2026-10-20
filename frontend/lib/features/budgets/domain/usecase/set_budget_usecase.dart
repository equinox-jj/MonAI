import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/budgets/domain/validation/budget_limit_rule.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';

/// The month and limit to save.
typedef SetBudgetParams = ({DateTime month, int limit});

/// Sets a month's spending limit, after checking it with the backend's rule.
class SetBudgetUseCase implements UseCase<Budget, SetBudgetParams> {
  SetBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Either<Failure, Budget>> call(SetBudgetParams params) async {
    if (BudgetLimitRule.check(params.limit) case final error?) {
      return Left(Failure.validation([error]));
    }
    return _repository.setBudget(params.month, params.limit);
  }
}
