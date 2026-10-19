import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/repository/auth_repository_impl.dart';

class _MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late _MockAuthLocalDataSource local;
  late AuthRepositoryImpl repository;

  setUp(() {
    local = _MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(local: local);
  });

  group('isOnboardingCompleted', () {
    test('returns the stored flag', () async {
      // Arrange
      when(() => local.isOnboardingCompleted()).thenAnswer((_) async => true);

      // Act
      final result = await repository.isOnboardingCompleted();

      // Assert
      expect(result, const Right<Failure, bool>(true));
    });

    test('returns a CacheFailure when reading fails', () async {
      // Arrange
      when(() => local.isOnboardingCompleted())
          .thenThrow(const CacheException(message: 'boom'));

      // Act
      final result = await repository.isOnboardingCompleted();

      // Assert
      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('completeOnboarding', () {
    test('saves the flag and returns unit', () async {
      // Arrange
      when(() => local.markOnboardingCompleted()).thenAnswer((_) async {});

      // Act
      final result = await repository.completeOnboarding();

      // Assert
      expect(result, const Right<Failure, Unit>(unit));
      verify(() => local.markOnboardingCompleted()).called(1);
    });

    test('returns a CacheFailure when saving fails', () async {
      // Arrange
      when(() => local.markOnboardingCompleted())
          .thenThrow(const CacheException(message: 'boom'));

      // Act
      final result = await repository.completeOnboarding();

      // Assert
      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });
}
