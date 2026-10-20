import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/local_cache.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/storage/app_preferences.dart';
import 'package:monai/core/storage/token_storage.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';

class _MockAppPreferences extends Mock implements AppPreferences {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLocalCache extends Mock implements LocalCache {}

void main() {
  late _MockAppPreferences preferences;
  late _MockTokenStorage tokenStorage;
  late _MockLocalCache localCache;
  late SessionManager sessionManager;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    preferences = _MockAppPreferences();
    tokenStorage = _MockTokenStorage();
    localCache = _MockLocalCache();
    sessionManager = SessionManager();
    dataSource = AuthLocalDataSourceImpl(
      preferences: preferences,
      tokenStorage: tokenStorage,
      localCache: localCache,
      sessionManager: sessionManager,
    );
    when(() => tokenStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => localCache.clear()).thenAnswer((_) async {});
  });

  tearDown(() => sessionManager.dispose());

  group('onboarding', () {
    test('returns the stored onboarding flag', () async {
      // Arrange
      when(() => preferences.isOnboardingCompleted())
          .thenAnswer((_) async => true);

      // Act
      final result = await dataSource.isOnboardingCompleted();

      // Assert
      expect(result, isTrue);
    });

    test('saves the onboarding flag', () async {
      // Arrange
      when(() => preferences.setOnboardingCompleted()).thenAnswer((_) async {});

      // Act
      await dataSource.markOnboardingCompleted();

      // Assert
      verify(() => preferences.setOnboardingCompleted()).called(1);
    });

    test('a storage error becomes a CacheException', () async {
      // Arrange
      when(() => preferences.setOnboardingCompleted())
          .thenThrow(StateError('disk full'));

      // Act
      final call = dataSource.markOnboardingCompleted();

      // Assert
      await expectLater(call, throwsA(isA<CacheException>()));
    });
  });

  group('startSession', () {
    test('stores the token and signs the session in', () async {
      // Arrange
      // (mocks from setUp)

      // Act
      await dataSource.startSession('token');

      // Assert
      verify(() => tokenStorage.saveAccessToken('token')).called(1);
      expect(sessionManager.status.value, SessionStatus.signedIn);
    });

    test('stays signed out when the token cannot be stored', () async {
      // Arrange
      when(() => tokenStorage.saveAccessToken(any()))
          .thenThrow(StateError('keystore'));

      // Act
      final call = dataSource.startSession('token');

      // Assert
      await expectLater(call, throwsA(isA<CacheException>()));
      expect(sessionManager.status.value, SessionStatus.signedOut);
    });
  });

  group('restoreSession', () {
    test('signs in when a token is stored', () async {
      // Arrange
      when(() => tokenStorage.readAccessToken())
          .thenAnswer((_) async => 'token');

      // Act
      final result = await dataSource.restoreSession();

      // Assert
      expect(result, isTrue);
      expect(sessionManager.status.value, SessionStatus.signedIn);
    });

    test('stays signed out without a token', () async {
      // Arrange
      when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => '');

      // Act
      final result = await dataSource.restoreSession();

      // Assert
      expect(result, isFalse);
      expect(sessionManager.status.value, SessionStatus.signedOut);
    });
  });
}
