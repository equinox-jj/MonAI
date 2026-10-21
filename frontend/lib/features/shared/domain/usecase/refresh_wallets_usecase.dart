import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

class RefreshWalletsUseCase implements UseCase<List<Wallet>, NoParams> {
  RefreshWalletsUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, List<Wallet>>> call(NoParams params) =>
      _repository.refreshWallets();
}
