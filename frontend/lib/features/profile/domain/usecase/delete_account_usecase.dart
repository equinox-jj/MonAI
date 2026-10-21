import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/profile/domain/validation/profile_input_validator.dart';
import 'package:monai/features/shared/domain/usecase/logout_usecase.dart';

/// Deletes the account and everything in it, confirmed with the user's
/// password, then signs out here: the token and the cache go, and
/// navigation follows the session to Sign in. A missing password fails as
/// [ValidationFailure] without calling the server.
class DeleteAccountUseCase implements UseCase<Unit, String> {
  DeleteAccountUseCase({required this._repository, required this._logout});

  final ProfileRepository _repository;
  final LogoutUseCase _logout;

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    if (ProfileInputValidator.password(params) case final error?) {
      return Left(Failure.validation([error]));
    }
    final deleted = await _repository.deleteAccount(params);
    if (deleted case Left()) return deleted;
    // The account is gone; a failed sign-out still leaves nothing to use.
    await _logout(const NoParams());
    return const Right(unit);
  }
}
