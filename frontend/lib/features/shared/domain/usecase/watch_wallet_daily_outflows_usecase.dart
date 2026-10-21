import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

/// Each day's money leaving a wallet in a month, for its chart.
class WatchWalletDailyOutflowsUseCase
    implements StreamUseCase<Map<DateTime, int>, WalletDailyOutflowsParams> {
  WatchWalletDailyOutflowsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, Map<DateTime, int>>> call(
    WalletDailyOutflowsParams params,
  ) => _repository.watchDailyOutflows(params.month, params.walletId);
}

/// The wallet and month (the first of the month) to chart.
class WalletDailyOutflowsParams {
  const WalletDailyOutflowsParams({
    required this.month,
    required this.walletId,
  });

  final DateTime month;
  final String walletId;
}
