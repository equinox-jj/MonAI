import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/event/transaction_deletion_events.dart';

/// Each transaction deleted from now on, as it was before the delete.
class WatchTransactionDeletionsUseCase
    implements StreamUseCase<Transaction, NoParams> {
  WatchTransactionDeletionsUseCase(this._events);

  final TransactionDeletionEvents _events;

  @override
  Stream<Either<Failure, Transaction>> call(NoParams params) =>
      _events.stream.map(Right.new);
}
