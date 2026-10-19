import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/logout_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  test('LogoutUseCase ends the session through the repository', () async {
    // Arrange
    when(() => repository.logout())
        .thenAnswer((_) async => const Right(SessionStatus.signedOut));

    // Act
    final result = await LogoutUseCase(repository)(const NoParams());

    // Assert
    expect(
      result,
      const Right<Failure, SessionStatus>(SessionStatus.signedOut),
    );
    verify(() => repository.logout()).called(1);
  });
}
