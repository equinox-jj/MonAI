import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';

class WatchDailyNetsUseCase
    implements StreamUseCase<Map<DateTime, int>, TransactionListParams> {
  WatchDailyNetsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, Map<DateTime, int>>> call(
    TransactionListParams params,
  ) => _repository.watchDailyNets(params.month, params.filter);
}
