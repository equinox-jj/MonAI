import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late CompleteOnboardingUseCase useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = CompleteOnboardingUseCase(repository);
  });

  test('marks onboarding as completed', () async {
    // Arrange
    when(() => repository.completeOnboarding())
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, const Right<Failure, bool>(true));
    verify(() => repository.completeOnboarding()).called(1);
  });

  test('passes a failure through unchanged', () async {
    // Arrange
    const failure = Failure.cache();
    when(() => repository.completeOnboarding())
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, const Left<Failure, bool>(failure));
  });
}
