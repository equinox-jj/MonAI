import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';

class ChangePasswordUseCase
    implements UseCase<SessionStatus, ChangePasswordParams> {
  ChangePasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SessionStatus>> call(
    ChangePasswordParams params,
  ) async {
    final errors = AuthInputValidator.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    return _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}
