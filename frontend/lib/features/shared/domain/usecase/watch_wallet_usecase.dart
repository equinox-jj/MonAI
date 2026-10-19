import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

/// One wallet by id; null when it isn't cached.
class WatchWalletUseCase implements StreamUseCase<Wallet?, String> {
  WatchWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Stream<Either<Failure, Wallet?>> call(String id) =>
      _repository.watchWallet(id);
}
