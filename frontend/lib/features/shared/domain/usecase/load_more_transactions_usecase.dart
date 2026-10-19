import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';

/// Fetches the next page of a transaction list; true when more follow.
class LoadMoreTransactionsUseCase
    implements UseCase<bool, TransactionListParams> {
  LoadMoreTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, bool>> call(TransactionListParams params) =>
      _repository.loadMoreTransactions(params.month, params.filter);
}
