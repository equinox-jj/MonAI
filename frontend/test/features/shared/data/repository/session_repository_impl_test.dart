import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/shared/data/datasources/session_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/session_remote_datasource.dart';
import 'package:monai/features/shared/data/repository/session_repository_impl.dart';

class _MockSessionRemoteDataSource extends Mock
    implements SessionRemoteDataSource {}

class _MockSessionLocalDataSource extends Mock
    implements SessionLocalDataSource {}

void main() {
  late _MockSessionRemoteDataSource remote;
  late _MockSessionLocalDataSource local;
  late SessionRepositoryImpl repository;

  setUp(() {
    remote = _MockSessionRemoteDataSource();
    local = _MockSessionLocalDataSource();
    repository = SessionRepositoryImpl(remote: remote, local: local);
    when(() => local.endSession()).thenAnswer((_) async {});
  });

  group('logout', () {
    test('ends the session', () async {
      // Arrange
      // (mocks from setUp)

      // Act
      final result = await repository.logout();

      // Assert
      expect(
        result,
        const Right<Failure, SessionStatus>(SessionStatus.signedOut),
      );
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

  group('logoutAllDevices', () {
    test('revokes the tokens on the server, then ends the session', () async {
      // Arrange
      when(() => remote.logoutAll()).thenAnswer((_) async {});

      // Act
      final result = await repository.logoutAllDevices();

      // Assert
      expect(
        result,
        const Right<Failure, SessionStatus>(SessionStatus.signedOut),
      );
      verifyInOrder([() => remote.logoutAll(), () => local.endSession()]);
    });

    test('a failed request keeps the session', () async {
      // Arrange
      when(() => remote.logoutAll()).thenThrow(const NetworkException());

      // Act
      final result = await repository.logoutAllDevices();

      // Assert
      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
      verifyNever(() => local.endSession());
    });
  });
}
