import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:monai/features/auth/data/model/auth_response.dart';
import 'package:monai/features/auth/data/model/change_password_request.dart';
import 'package:monai/features/auth/data/model/login_request.dart';
import 'package:monai/features/auth/data/model/register_request.dart';
import 'package:monai/features/auth/data/repository/auth_repository_impl.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/shared/data/datasources/session_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_local_datasource.dart';
import 'package:monai/features/shared/data/mapper/user_mapper.dart';

import '../../../../helpers/database_fixtures.dart';
import '../../../../helpers/entity_fixtures.dart';

class _MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class _MockSessionLocalDataSource extends Mock
    implements SessionLocalDataSource {}

final _data = Data(
  accessToken: 'token',
  tokenType: 'Bearer',
  expiresIn: 3600,
  user: User(
    id: 'u1',
    name: 'Ana',
    email: 'ana@monai.id',
    timezone: 'Asia/Jakarta',
    role: const Role(slug: 'user', name: 'User'),
    permissions: const [],
    createdAt: DateTime.utc(2026, 10, 1, 8),
  ),
);

final _response = AuthResponse(success: true, data: _data);

void main() {
  late _MockAuthLocalDataSource local;
  late _MockAuthRemoteDataSource remote;
  late _MockUserLocalDataSource users;
  late _MockSessionLocalDataSource session;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const ChangePasswordRequest(currentPassword: '', newPassword: ''),
    );
    registerFallbackValue(const LoginRequest(email: '', password: ''));
    registerFallbackValue(userRow());
    registerFallbackValue(
      const RegisterRequest(name: '', email: '', password: ''),
    );
  });

  setUp(() {
    local = _MockAuthLocalDataSource();
    remote = _MockAuthRemoteDataSource();
    users = _MockUserLocalDataSource();
    session = _MockSessionLocalDataSource();
    repository = AuthRepositoryImpl(
      remote: remote,
      local: local,
      users: users,
      session: session,
    );
    when(() => users.replace(any())).thenAnswer((_) async {});
    when(() => local.clearCache()).thenAnswer((_) async {});
    when(() => local.startSession(any())).thenAnswer((_) async {});
    when(() => session.endSession()).thenAnswer((_) async {});
    when(() => session.endSessionAfterPasswordChange())
        .thenAnswer((_) async {});
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
    test('saves the flag and returns it', () async {
      // Arrange
      when(() => local.markOnboardingCompleted()).thenAnswer((_) async {});

      // Act
      final result = await repository.completeOnboarding();

      // Assert
      expect(result, const Right<Failure, bool>(true));
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
    test('sends the credentials, clears the cache, caches the user, then '
        'starts the session', () async {
      // Arrange
      when(() => remote.login(any())).thenAnswer((_) async => _response);

      // Act
      final result = await repository.login(email: 'a@b.co', password: 'pw');

      // Assert
      expect(result, Right<Failure, AuthSession>(authSession()));
      verify(
        () => remote.login(const LoginRequest(email: 'a@b.co', password: 'pw')),
      ).called(1);
      final calls = verifyInOrder([
        () => local.clearCache(),
        () => users.replace(captureAny()),
        () => local.startSession('token'),
      ]);
      final cached = calls[1].captured.single as UserRow;
      expect(cached.toEntity(), user());
    });

    test('a user that fails to cache still signs in', () async {
      // Arrange
      when(() => remote.login(any())).thenAnswer((_) async => _response);
      when(() => users.replace(any()))
          .thenThrow(const CacheException(message: 'disk full'));

      // Act
      final result = await repository.login(email: 'a@b.co', password: 'pw');

      // Assert
      expect(result, Right<Failure, AuthSession>(authSession()));
      verify(() => local.startSession('token')).called(1);
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
      verifyNever(() => users.replace(any()));
      verifyNever(() => local.startSession(any()));
    });

    test('a response without the user starts no session', () async {
      // Arrange
      when(() => remote.login(any())).thenAnswer(
        (_) async =>
            AuthResponse(success: true, data: _data.copyWith(user: null)),
      );

      // Act
      final result = await repository.login(email: 'a@b.co', password: 'pw');

      // Assert
      expect(result.getLeft().toNullable(), isA<UnknownFailure>());
      verifyNever(() => local.clearCache());
      verifyNever(() => users.replace(any()));
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
      expect(result, Right<Failure, AuthSession>(authSession()));
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

  group('changePassword', () {
    test('changes the password, then ends the session', () async {
      // Arrange
      when(() => remote.changePassword(any()))
          .thenAnswer((_) async => _response);

      // Act
      final result = await repository.changePassword(
        currentPassword: 'old',
        newPassword: 'new-secret',
      );

      // Assert
      expect(
        result,
        const Right<Failure, SessionStatus>(SessionStatus.passwordChanged),
      );
      verify(
        () => remote.changePassword(
          const ChangePasswordRequest(
            currentPassword: 'old',
            newPassword: 'new-secret',
          ),
        ),
      ).called(1);
      verify(() => session.endSessionAfterPasswordChange()).called(1);
      verifyNever(() => session.endSession());
      verifyNever(() => local.startSession(any()));
    });

    test('a wrong current password keeps its code and the session', () async {
      // Arrange
      when(() => remote.changePassword(any()))
          .thenThrow(const ValidationException([], code: 'invalid_password'));

      // Act
      final result = await repository.changePassword(
        currentPassword: 'wrong',
        newPassword: 'new-secret',
      );

      // Assert
      expect(result.getLeft().toNullable()?.code, 'invalid_password');
      verifyNever(() => session.endSessionAfterPasswordChange());
    });
  });
}
