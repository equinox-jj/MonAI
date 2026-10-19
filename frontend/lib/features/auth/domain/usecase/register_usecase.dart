import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/validation/auth_input.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';

/// Creates an account and signs in. Invalid input fails as
/// [ValidationFailure] without calling the server, in the same shape as the
/// server's own 422.
class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) async {
    final name = params.name.normalizedName;
    final email = params.email.normalizedEmail;
    final errors = AuthInputValidator.register(
      name: name,
      email: email,
      password: params.password,
    );
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    return _repository.register(
      name: name,
      email: email,
      password: params.password,
    );
  }
}

/// The register form as typed.
class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
