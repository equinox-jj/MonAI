import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';

/// Re-fetches the newest transactions of a month.
class RefreshRecentTransactionsUseCase
    implements UseCase<List<Transaction>, RecentTransactionsParams> {
  RefreshRecentTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(
    RecentTransactionsParams params,
  ) => _repository.refreshRecentTransactions(params.month, limit: params.limit);
}
