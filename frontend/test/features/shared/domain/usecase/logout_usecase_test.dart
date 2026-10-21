import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/session_repository.dart';
import 'package:monai/features/shared/domain/usecase/logout_usecase.dart';

class _MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late _MockSessionRepository repository;

  setUp(() => repository = _MockSessionRepository());

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
