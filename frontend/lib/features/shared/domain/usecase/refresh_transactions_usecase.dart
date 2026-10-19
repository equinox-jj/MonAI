import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';

/// Re-fetches the first page of a transaction list; true when more follow.
class RefreshTransactionsUseCase
    implements UseCase<bool, TransactionListParams> {
  RefreshTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, bool>> call(TransactionListParams params) =>
      _repository.refreshTransactions(params.month, params.filter);
}
