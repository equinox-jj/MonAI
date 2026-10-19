import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';

/// Each day's net (income minus expenses) of a transaction list, for its day
/// headers.
class WatchDailyNetsUseCase
    implements StreamUseCase<Map<DateTime, int>, TransactionListParams> {
  WatchDailyNetsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, Map<DateTime, int>>> call(
    TransactionListParams params,
  ) => _repository.watchDailyNets(params.month, params.filter);
}
