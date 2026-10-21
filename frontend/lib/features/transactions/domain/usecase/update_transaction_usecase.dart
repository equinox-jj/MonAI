import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

/// Saves an edited transaction, then refreshes the totals of its old and new
/// month. Invalid input fails as [ValidationFailure] without calling the
/// server.
class UpdateTransactionUseCase
    implements UseCase<Transaction, UpdateTransactionParams> {
  UpdateTransactionUseCase({
    required this._repository,
    required this._refreshDependents,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final TransactionRepository _repository;
  final RefreshTransactionDependentsUseCase _refreshDependents;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, Transaction>> call(
    UpdateTransactionParams params,
  ) async {
    final input = params.input.normalized;
    final errors = TransactionInputValidator.validate(input, today: _now());
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    final result = await _repository.updateTransaction(
      params.original.id,
      input,
    );
    if (result case Right(value: final updated)) {
      await _refreshDependents([params.original.date, updated.date]);
    }
    return result;
  }
}

/// The transaction as it was, and the edited form.
class UpdateTransactionParams {
  const UpdateTransactionParams({required this.original, required this.input});

  final Transaction original;
  final TransactionInput input;
}
