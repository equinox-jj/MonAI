import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/restore_session_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  test('RestoreSessionUseCase returns whether a session exists', () async {
    // Arrange
    when(() => repository.restoreSession())
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await RestoreSessionUseCase(repository)(const NoParams());

    // Assert
    expect(result, const Right<Failure, bool>(true));
  });
}
