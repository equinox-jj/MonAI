import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';

class CreateWalletUseCase implements UseCase<Wallet, WalletInput> {
  CreateWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(WalletInput params) async {
    final input = params.normalized;
    final errors = WalletInputValidator.validate(input);
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    return _repository.createWallet(input);
  }
}
