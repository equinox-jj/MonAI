import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';

/// Saves an edited wallet, sending only what changed; an unchanged form
/// makes no request. Invalid input fails as [ValidationFailure] without
/// calling the server.
///
/// The type and color can't be cleared, and the default can only be moved
/// to this wallet, never unset: another wallet has to become the default.
class UpdateWalletUseCase implements UseCase<Wallet, UpdateWalletParams> {
  UpdateWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(UpdateWalletParams params) async {
    final input = params.input.normalized;
    final errors = WalletInputValidator.validate(
      input.copyWith(providerId: params.wallet.providerId),
    );
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    final changes = _changes(params.wallet, input);
    if (changes.isEmpty) return Right(params.wallet);
    return _repository.updateWallet(params.wallet.id, changes);
  }

  WalletChanges _changes(Wallet wallet, WalletInput input) => WalletChanges(
    name: input.name.isEmpty || input.name == wallet.name ? null : input.name,
    type: input.type == wallet.type ? null : input.type,
    initialBalance: input.initialBalance == wallet.initialBalance
        ? null
        : input.initialBalance,
    color: input.color == wallet.color ? null : input.color,
    isDefault: input.isDefault && !wallet.isDefault ? true : null,
  );
}

/// The wallet as it is and the edited form.
class UpdateWalletParams {
  const UpdateWalletParams({required this.wallet, required this.input});

  final Wallet wallet;
  final WalletInput input;
}
