import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/session_repository.dart';

/// Signs out of this device; navigation follows the session to Sign in.
class LogoutUseCase implements UseCase<SessionStatus, NoParams> {
  LogoutUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, SessionStatus>> call(NoParams params) =>
      _repository.logout();
}
