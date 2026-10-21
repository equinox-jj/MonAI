import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

/// From the cache when it is there, else from the server, e.g. to open the
/// edit form from a link.
class GetTransactionUseCase implements UseCase<Transaction, String> {
  GetTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Transaction>> call(String id) async {
    if (await _cached(id) case Right(value: final Transaction transaction)) {
      return Right(transaction);
    }
    final refreshed = await _repository.refreshTransaction(id);
    if (refreshed case Left(value: final failure)) return Left(failure);
    return switch (await _cached(id)) {
      Left(value: final failure) => Left(failure),
      Right(value: final transaction?) => Right(transaction),
      Right(value: null) => const Left(Failure.notFound()),
    };
  }

  Future<Either<Failure, Transaction?>> _cached(String id) =>
      _repository.watchTransaction(id).first;
}
