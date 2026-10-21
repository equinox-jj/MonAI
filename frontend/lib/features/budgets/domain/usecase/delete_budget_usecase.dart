import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';

/// Removes a month's budget; takes the month.
class DeleteBudgetUseCase implements UseCase<Unit, DateTime> {
  DeleteBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DateTime month) =>
      _repository.deleteBudget(month);
}
