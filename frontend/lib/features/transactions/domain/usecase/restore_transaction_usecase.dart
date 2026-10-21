import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';

/// Undoes a delete, then refreshes the totals it changes. Fails with code
/// `wallet_archived` when one of its wallets has been archived since.
class RestoreTransactionUseCase implements UseCase<Transaction, String> {
  RestoreTransactionUseCase({
    required this._repository,
    required this._refreshDependents,
  });

  final TransactionRepository _repository;
  final RefreshTransactionDependentsUseCase _refreshDependents;

  @override
  Future<Either<Failure, Transaction>> call(String id) async {
    final result = await _repository.restoreTransaction(id);
    if (result case Right(value: final restored)) {
      await _refreshDependents([restored.date]);
    }
    return result;
  }
}
