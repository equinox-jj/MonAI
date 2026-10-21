import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/wallets/domain/validation/default_wallet_rule.dart';

/// The default wallet is refused without calling the server; one with
/// transactions fails with `wallet_has_transactions` and can be archived
/// instead.
class DeleteWalletUseCase implements UseCase<Wallet?, Wallet> {
  DeleteWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet?>> call(Wallet wallet) async {
    if (wallet.isDefault) return const Left(DefaultWalletRule.deleteFailure);
    return _repository.deleteWallet(wallet.id);
  }
}
