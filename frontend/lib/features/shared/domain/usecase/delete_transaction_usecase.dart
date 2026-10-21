import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/event/transaction_deletion_events.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';

/// Deletes a transaction, announces it for an undo, then refreshes the
/// totals it changed. Gives the deleted copy, null when it wasn't cached.
class DeleteTransactionUseCase implements UseCase<Transaction?, String> {
  DeleteTransactionUseCase({
    required this._repository,
    required this._events,
    required this._refreshDependents,
  });

  final TransactionRepository _repository;
  final TransactionDeletionEvents _events;
  final RefreshTransactionDependentsUseCase _refreshDependents;

  @override
  Future<Either<Failure, Transaction?>> call(String id) async {
    final result = await _repository.deleteTransaction(id);
    switch (result) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final deleted):
        // Announced before the refresh so the undo shows at once. Without a
        // cached copy there is nothing to restore from, nor a known month.
        if (deleted != null) _events.emit(deleted);
        await _refreshDependents([?deleted?.date]);
        return Right(deleted);
    }
  }
}
