import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

/// One transaction by id; null when it isn't cached.
class WatchTransactionUseCase implements StreamUseCase<Transaction?, String> {
  WatchTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, Transaction?>> call(String id) =>
      _repository.watchTransaction(id);
}
