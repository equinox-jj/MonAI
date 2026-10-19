import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/is_onboarding_completed_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late IsOnboardingCompletedUseCase useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = IsOnboardingCompletedUseCase(repository);
  });

  test('returns the repository flag', () async {
    // Arrange
    when(() => repository.isOnboardingCompleted())
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, const Right<Failure, bool>(true));
  });

  test('passes a failure through unchanged', () async {
    // Arrange
    const failure = Failure.cache();
    when(() => repository.isOnboardingCompleted())
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, const Left<Failure, bool>(failure));
  });
}
