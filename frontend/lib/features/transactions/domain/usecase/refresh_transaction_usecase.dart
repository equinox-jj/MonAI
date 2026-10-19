import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

/// Re-fetches one transaction; one deleted elsewhere fails as
/// [NotFoundFailure] and leaves the cache.
class RefreshTransactionUseCase implements UseCase<Transaction, String> {
  RefreshTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Transaction>> call(String id) =>
      _repository.refreshTransaction(id);
}
