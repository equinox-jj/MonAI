import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

/// Brings an archived wallet back to the pickers.
class UnarchiveWalletUseCase implements UseCase<Wallet, String> {
  UnarchiveWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(String id) =>
      _repository.updateWallet(id, const WalletChanges(isArchived: false));
}
