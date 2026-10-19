import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:monai/features/auth/data/model/auth_response.dart';
import 'package:monai/features/auth/data/model/login_request.dart';
import 'package:monai/features/auth/data/model/register_request.dart';
import 'package:monai/features/auth/data/repository/auth_repository_impl.dart';

class _MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

const _response = AuthResponse(
  success: true,
  data: Data(accessToken: 'token', tokenType: 'Bearer', expiresIn: 3600),
);

void main() {
  late _MockAuthLocalDataSource local;
  late _MockAuthRemoteDataSource remote;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const LoginRequest(email: '', password: ''));
    registerFallbackValue(
      const RegisterRequest(name: '', email: '', password: ''),
    );
  });

  setUp(() {
    local = _MockAuthLocalDataSource();
    remote = _MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remote: remote, local: local);
    when(() => local.clearCache()).thenAnswer((_) async {});
    when(() => local.startSession(any())).thenAnswer((_) async {});
    when(() => local.endSession()).thenAnswer((_) async {});
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

  group('login', () {
    test('sends the credentials, clears the cache, then starts the '
        'session', () async {
      // Arrange
      when(() => remote.login(any())).thenAnswer((_) async => _response);

      // Act
      final result = await repository.login(email: 'a@b.co', password: 'pw');

      // Assert
      expect(result, const Right<Failure, Unit>(unit));
      verify(
        () => remote.login(const LoginRequest(email: 'a@b.co', password: 'pw')),
      ).called(1);
      verifyInOrder([
        () => local.clearCache(),
        () => local.startSession('token'),
      ]);
    });

    test('a response without a token starts no session', () async {
      // Arrange
      when(() => remote.login(any()))
          .thenAnswer((_) async => const AuthResponse(success: true));

      // Act
      final result = await repository.login(email: 'a@b.co', password: 'pw');

      // Assert
      expect(result.getLeft().toNullable(), isA<UnknownFailure>());
      verifyNever(() => local.clearCache());
      verifyNever(() => local.startSession(any()));
    });

    test('a rejected login keeps its code and starts no session', () async {
      // Arrange
      when(() => remote.login(any()))
          .thenThrow(const UnauthorizedException(code: 'invalid_credentials'));

      // Act
      final result = await repository.login(email: 'a@b.co', password: 'pw');

      // Assert
      expect(
        result.getLeft().toNullable(),
        isA<UnauthorizedFailure>().having(
          (f) => f.code,
          'code',
          'invalid_credentials',
        ),
      );
      verifyNever(() => local.startSession(any()));
    });
  });

  group('register', () {
    test('sends the form and starts the session', () async {
      // Arrange
      when(() => remote.register(any())).thenAnswer((_) async => _response);

      // Act
      final result = await repository.register(
        name: 'Ana',
        email: 'a@b.co',
        password: 'password1',
      );

      // Assert
      expect(result, const Right<Failure, Unit>(unit));
      verify(
        () => remote.register(
          const RegisterRequest(
            name: 'Ana',
            email: 'a@b.co',
            password: 'password1',
          ),
        ),
      ).called(1);
      verify(() => local.startSession('token')).called(1);
    });

    test('a taken email is a ConflictFailure', () async {
      // Arrange
      when(() => remote.register(any()))
          .thenThrow(const ConflictException(code: 'conflict'));

      // Act
      final result = await repository.register(
        name: 'Ana',
        email: 'a@b.co',
        password: 'password1',
      );

      // Assert
      expect(result.getLeft().toNullable(), isA<ConflictFailure>());
      verifyNever(() => local.startSession(any()));
    });
  });

  group('logout', () {
    test('ends the session', () async {
      // Arrange
      // (mocks from setUp)

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, const Right<Failure, Unit>(unit));
      verify(() => local.endSession()).called(1);
    });

    test('returns a CacheFailure when the token cannot be removed', () async {
      // Arrange
      when(() => local.endSession())
          .thenThrow(const CacheException(message: 'keystore'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('restoreSession', () {
    test('returns whether a session was restored', () async {
      // Arrange
      when(() => local.restoreSession()).thenAnswer((_) async => true);

      // Act
      final result = await repository.restoreSession();

      // Assert
      expect(result, const Right<Failure, bool>(true));
    });
  });
}
