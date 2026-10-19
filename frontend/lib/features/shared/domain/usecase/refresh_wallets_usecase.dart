import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

/// Re-fetches every wallet and its balance.
class RefreshWalletsUseCase implements UseCase<List<Wallet>, NoParams> {
  RefreshWalletsUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, List<Wallet>>> call(NoParams params) =>
      _repository.refreshWallets();
}
