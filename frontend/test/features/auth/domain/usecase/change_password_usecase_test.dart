import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/change_password_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late ChangePasswordUseCase useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = ChangePasswordUseCase(repository);
    when(
      () => repository.changePassword(
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async => const Right(SessionStatus.signedOut));
  });

  test('sends the passwords as typed', () async {
    // Arrange
    const params = ChangePasswordParams(
      currentPassword: ' old ',
      newPassword: ' new-secret ',
    );

    // Act
    final result = await useCase(params);

    // Assert
    expect(
      result,
      const Right<Failure, SessionStatus>(SessionStatus.signedOut),
    );
    verify(
      () => repository.changePassword(
        currentPassword: ' old ',
        newPassword: ' new-secret ',
      ),
    ).called(1);
  });

  test('invalid input fails without calling the server', () async {
    // Arrange
    const params = ChangePasswordParams(
      currentPassword: 'same-secret',
      newPassword: 'same-secret',
    );

    // Act
    final result = await useCase(params);

    // Assert
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(
      () => repository.changePassword(
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    );
  });
}
