import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/wallets/domain/validation/default_wallet_rule.dart';

/// Archives a wallet: it leaves pickers but keeps its transactions. The
/// default wallet is refused without calling the server.
class ArchiveWalletUseCase implements UseCase<Wallet, Wallet> {
  ArchiveWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(Wallet wallet) async {
    if (wallet.isDefault) return const Left(DefaultWalletRule.archiveFailure);
    return _repository.updateWallet(
      wallet.id,
      const WalletChanges(isArchived: true),
    );
  }
}
