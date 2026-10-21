import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/local_cache.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/storage/token_storage.dart';
import 'package:monai/features/shared/data/datasources/session_local_datasource.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLocalCache extends Mock implements LocalCache {}

void main() {
  late _MockTokenStorage tokenStorage;
  late _MockLocalCache localCache;
  late SessionManager sessionManager;
  late SessionLocalDataSourceImpl dataSource;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    localCache = _MockLocalCache();
    sessionManager = SessionManager();
    dataSource = SessionLocalDataSourceImpl(
      tokenStorage: tokenStorage,
      localCache: localCache,
      sessionManager: sessionManager,
    );
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
    when(() => localCache.clear()).thenAnswer((_) async {});
  });

  tearDown(() => sessionManager.dispose());

  group('endSession', () {
    test('clears the token and cache and signs out', () async {
      // Arrange
      sessionManager.signedIn();

      // Act
      await dataSource.endSession();

      // Assert
      verify(() => tokenStorage.clear()).called(1);
      verify(() => localCache.clear()).called(1);
      expect(sessionManager.status.value, SessionStatus.signedOut);
    });

    test('signs out even when the cache fails to clear', () async {
      // Arrange
      sessionManager.signedIn();
      when(() => localCache.clear()).thenThrow(StateError('disk'));

      // Act
      await dataSource.endSession();

      // Assert
      expect(sessionManager.status.value, SessionStatus.signedOut);
    });

    test('stays signed in when the token cannot be removed', () async {
      // Arrange
      sessionManager.signedIn();
      when(() => tokenStorage.clear()).thenThrow(StateError('keystore'));

      // Act
      final call = dataSource.endSession();

      // Assert
      await expectLater(call, throwsA(isA<CacheException>()));
      expect(sessionManager.status.value, SessionStatus.signedIn);
    });
  });

  group('endSessionAfterPasswordChange', () {
    test('clears the token and cache and shows the notice', () async {
      // Arrange
      sessionManager.signedIn();

      // Act
      await dataSource.endSessionAfterPasswordChange();

      // Assert
      verify(() => tokenStorage.clear()).called(1);
      verify(() => localCache.clear()).called(1);
      expect(sessionManager.status.value, SessionStatus.passwordChanged);
    });

    test('shows the notice even when the cache fails to clear', () async {
      // Arrange
      sessionManager.signedIn();
      when(() => localCache.clear()).thenThrow(StateError('disk'));

      // Act
      await dataSource.endSessionAfterPasswordChange();

      // Assert
      expect(sessionManager.status.value, SessionStatus.passwordChanged);
    });

    test('stays signed in when the token cannot be removed', () async {
      // Arrange
      sessionManager.signedIn();
      when(() => tokenStorage.clear()).thenThrow(StateError('keystore'));

      // Act
      final call = dataSource.endSessionAfterPasswordChange();

      // Assert
      await expectLater(call, throwsA(isA<CacheException>()));
      expect(sessionManager.status.value, SessionStatus.signedIn);
    });
  });
}
