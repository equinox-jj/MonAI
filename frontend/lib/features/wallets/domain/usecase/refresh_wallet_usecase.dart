import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

/// Re-fetches one wallet; one deleted elsewhere fails as [NotFoundFailure]
/// and leaves the cache.
class RefreshWalletUseCase implements UseCase<Wallet, String> {
  RefreshWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(String id) =>
      _repository.refreshWallet(id);
}
