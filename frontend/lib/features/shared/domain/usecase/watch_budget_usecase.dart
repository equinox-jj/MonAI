import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';

/// The budget of a month (the first of the month); null when none is set.
class WatchBudgetUseCase implements StreamUseCase<Budget?, DateTime> {
  WatchBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Stream<Either<Failure, Budget?>> call(DateTime month) =>
      _repository.watchBudget(month);
}
