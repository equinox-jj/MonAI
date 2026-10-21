import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';

/// Saves one reviewed quick-add draft as an AI quick-add transaction.
/// Invalid input fails as [ValidationFailure] without calling the server.
class SaveQuickAddDraftUseCase
    implements UseCase<Transaction, TransactionInput> {
  SaveQuickAddDraftUseCase(this._create);

  final CreateTransactionUseCase _create;

  @override
  Future<Either<Failure, Transaction>> call(TransactionInput params) =>
      _create(params.copyWith(source: TransactionSource.quickAdd));
}
