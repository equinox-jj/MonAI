import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/login_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

final _session = authSession();

void main() {
  late _MockAuthRepository repository;
  late LoginUseCase login;

  setUp(() {
    repository = _MockAuthRepository();
    login = LoginUseCase(repository);
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => Right(_session));
  });

  test('sends the cleaned-up email and the password as typed', () async {
    // Arrange
    const params = LoginParams(email: ' Ana@B.co ', password: ' pw ');

    // Act
    final result = await login(params);

    // Assert
    expect(result, Right<Failure, AuthSession>(_session));
    verify(() => repository.login(email: 'ana@b.co', password: ' pw '))
        .called(1);
  });

  test('invalid input fails without calling the server', () async {
    // Arrange
    const params = LoginParams(email: '   ', password: '');

    // Act
    final result = await login(params);

    // Assert
    final failure = result.getLeft().toNullable();
    expect(failure, isA<ValidationFailure>());
    expect((failure! as ValidationFailure).fieldErrors.map((e) => e.field), [
      'email',
      'password',
    ]);
    verifyNever(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });
}
