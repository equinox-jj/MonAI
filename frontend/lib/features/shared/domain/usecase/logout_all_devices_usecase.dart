import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/session_repository.dart';

/// Signs out of every device; navigation follows the session to Sign in.
class LogoutAllDevicesUseCase implements UseCase<SessionStatus, NoParams> {
  LogoutAllDevicesUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, SessionStatus>> call(NoParams params) =>
      _repository.logoutAllDevices();
}
