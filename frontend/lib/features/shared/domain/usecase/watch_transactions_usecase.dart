import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';

/// The loaded rows of a transaction list. Grow the limit by
/// `TransactionRepository.pageSize` after each `LoadMoreTransactionsUseCase`.
class WatchTransactionsUseCase
    implements StreamUseCase<List<Transaction>, TransactionPageParams> {
  WatchTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, List<Transaction>>> call(
    TransactionPageParams params,
  ) => _repository.watchTransactions(
    params.month,
    params.filter,
    limit: params.limit,
  );
}
