import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';

/// The newest transactions of a month, for the home screen.
class WatchRecentTransactionsUseCase
    implements StreamUseCase<List<Transaction>, RecentTransactionsParams> {
  WatchRecentTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, List<Transaction>>> call(
    RecentTransactionsParams params,
  ) => _repository.watchRecentTransactions(params.month, limit: params.limit);
}
