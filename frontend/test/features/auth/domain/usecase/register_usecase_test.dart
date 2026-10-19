import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/register_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late RegisterUseCase register;

  setUp(() {
    repository = _MockAuthRepository();
    register = RegisterUseCase(repository);
    when(
      () => repository.register(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(unit));
  });

  test('sends the cleaned-up name and email', () async {
    // Arrange
    const params = RegisterParams(
      name: '  Ana Putri ',
      email: ' Ana@B.co',
      password: 'password1',
    );

    // Act
    final result = await register(params);

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(
      () => repository.register(
        name: 'Ana Putri',
        email: 'ana@b.co',
        password: 'password1',
      ),
    ).called(1);
  });

  test('a short password fails without calling the server', () async {
    // Arrange
    const params = RegisterParams(
      name: 'Ana',
      email: 'a@b.co',
      password: 'short',
    );

    // Act
    final result = await register(params);

    // Assert
    final failure = result.getLeft().toNullable();
    expect(failure, isA<ValidationFailure>());
    expect(
      (failure! as ValidationFailure).fieldErrors.single.code,
      'min_length',
    );
    verifyNever(
      () => repository.register(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });
}
