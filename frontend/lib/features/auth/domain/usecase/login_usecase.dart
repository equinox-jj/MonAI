import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/validation/auth_input.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';

/// Signs in. Invalid input fails as [ValidationFailure] without calling the
/// server, in the same shape as the server's own 422.
class LoginUseCase implements UseCase<AuthSession, LoginParams> {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSession>> call(LoginParams params) async {
    final email = params.email.normalizedEmail;
    final errors = AuthInputValidator.login(
      email: email,
      password: params.password,
    );
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    return _repository.login(email: email, password: params.password);
  }
}

/// The sign-in form as typed.
class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}
