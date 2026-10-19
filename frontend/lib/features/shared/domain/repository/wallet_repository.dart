import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';

/// The user's wallets. Reads come from the cache; refreshes and writes go to
/// the server and then update the cache.
abstract class WalletRepository {
  /// Wallets that aren't archived, default first, then by name.
  Stream<Either<Failure, List<Wallet>>> watchWallets();

  /// Every wallet, archived ones included, to label old transactions.
  Stream<Either<Failure, List<Wallet>>> watchAllWallets();

  /// The wallet with [id], or null when it isn't cached.
  Stream<Either<Failure, Wallet?>> watchWallet(String id);

  /// Replaces the cache with the server's wallets and gives them, archived
  /// ones included.
  Future<Either<Failure, List<Wallet>>> refreshWallets();

  /// Re-fetches one wallet and gives the cached copy; a wallet the server no
  /// longer has is dropped from the cache and fails as [NotFoundFailure].
  Future<Either<Failure, Wallet>> refreshWallet(String id);

  /// Creates a wallet.
  Future<Either<Failure, Wallet>> createWallet(WalletInput input);

  /// Changes a wallet.
  Future<Either<Failure, Wallet>> updateWallet(
    String id,
    WalletChanges changes,
  );

  /// Deletes a wallet that has no transactions; fails with code
  /// `wallet_has_transactions` otherwise. Gives the cached copy, null when it
  /// wasn't cached.
  Future<Either<Failure, Wallet?>> deleteWallet(String id);
}
