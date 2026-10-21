import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

/// Refreshes the totals it changes. Invalid input fails as
/// [ValidationFailure] without calling the server, in the shape of the
/// server's own 422.
class CreateTransactionUseCase
    implements UseCase<Transaction, TransactionInput> {
  CreateTransactionUseCase({
    required this._repository,
    required this._refreshDependents,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final TransactionRepository _repository;
  final RefreshTransactionDependentsUseCase _refreshDependents;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, Transaction>> call(TransactionInput params) async {
    final input = params.normalized;
    final errors = TransactionInputValidator.validate(input, today: _now());
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    final result = await _repository.createTransaction(input);
    if (result case Right(value: final transaction)) {
      await _refreshDependents([transaction.date]);
    }
    return result;
  }
}
