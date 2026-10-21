import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';

abstract class WalletRepository {
  Stream<Either<Failure, List<Wallet>>> watchWallets();

  /// Archived ones included, to label old transactions.
  Stream<Either<Failure, List<Wallet>>> watchAllWallets();

  Stream<Either<Failure, Wallet?>> watchWallet(String id);

  Future<Either<Failure, List<Wallet>>> refreshWallets();

  /// One the server no longer has is dropped from the cache and fails as
  /// [NotFoundFailure].
  Future<Either<Failure, Wallet>> refreshWallet(String id);

  Future<Either<Failure, Wallet>> createWallet(WalletInput input);

  Future<Either<Failure, Wallet>> updateWallet(
    String id,
    WalletChanges changes,
  );

  /// Fails with `wallet_has_transactions` when it has transactions. Gives the
  /// cached copy, null when it wasn't cached.
  Future<Either<Failure, Wallet?>> deleteWallet(String id);
}
