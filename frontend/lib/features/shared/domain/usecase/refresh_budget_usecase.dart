import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';

class RefreshBudgetUseCase implements UseCase<Budget?, DateTime> {
  RefreshBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Either<Failure, Budget?>> call(DateTime month) =>
      _repository.refreshBudget(month);
}
