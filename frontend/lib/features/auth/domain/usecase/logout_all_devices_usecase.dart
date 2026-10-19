import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

/// Signs out of every device; navigation follows the session to Sign in.
class LogoutAllDevicesUseCase implements UseCase<SessionStatus, NoParams> {
  LogoutAllDevicesUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SessionStatus>> call(NoParams params) =>
      _repository.logoutAllDevices();
}
