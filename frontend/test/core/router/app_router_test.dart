import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/domain/usecase/login_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/bloc/sign_in_bloc.dart';

class _MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

class _MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  group('sessionRedirect', () {
    test('a signed-in user leaves the auth screens for Home', () {
      // Arrange
      const locations = [
        AppRoutes.onboarding,
        AppRoutes.signIn,
        AppRoutes.register,
      ];

      // Act
      final targets = locations.map(
        (location) => sessionRedirect(.signedIn, location),
      );

      // Assert
      expect(targets, everyElement(AppRoutes.home));
    });

    test('a signed-out user is sent from Home to Sign in', () {
      // Arrange
      const location = AppRoutes.home;

      // Act
      final target = sessionRedirect(.signedOut, location);

      // Assert
      expect(target, AppRoutes.signIn);
    });

    test('a signed-out user may stay on the auth screens', () {
      // Arrange
      const location = AppRoutes.register;

      // Act
      final target = sessionRedirect(.signedOut, location);

      // Assert
      expect(target, isNull);
    });

    test('leaves the launch route to pick the first screen', () {
      // Arrange
      const location = AppRoutes.launch;

      // Act
      final target = sessionRedirect(.signedOut, location);

      // Assert
      expect(target, isNull);
    });

    test('an expired session stays put under the dialog', () {
      // Arrange
      const location = AppRoutes.home;

      // Act
      final target = sessionRedirect(SessionStatus.expired, location);

      // Assert
      expect(target, isNull);
    });
  });

  group('launchRedirect', () {
    test('a signed-in user starts on Home without reading the flag', () async {
      // Arrange
      var flagRead = false;
      Future<bool> isOnboardingCompleted() async => flagRead = true;

      // Act
      final target = await launchRedirect(.signedIn, isOnboardingCompleted);

      // Assert
      expect(target, AppRoutes.home);
      expect(flagRead, isFalse);
    });

    test(
      'a signed-out user who finished onboarding starts on Sign in',
      () async {
        // Arrange
        Future<bool> isOnboardingCompleted() async => true;

        // Act
        final target = await launchRedirect(.signedOut, isOnboardingCompleted);

        // Assert
        expect(target, AppRoutes.signIn);
      },
    );

    test('a signed-out user new to the app starts on Onboarding', () async {
      // Arrange
      Future<bool> isOnboardingCompleted() async => false;

      // Act
      final target = await launchRedirect(.signedOut, isOnboardingCompleted);

      // Assert
      expect(target, AppRoutes.onboarding);
    });
  });

  group('launch', () {
    setUp(() {
      sl
        ..registerFactory(
          () => OnboardingBloc(_MockCompleteOnboardingUseCase()),
        )
        ..registerFactory(() => SignInBloc(_MockLoginUseCase()));
    });

    tearDown(sl.reset);

    Future<GoRouter> pumpLaunch(
      WidgetTester tester, {
      required bool onboardingCompleted,
    }) async {
      final router = createAppRouter(
        sessionManager: SessionManager(),
        isOnboardingCompleted: () async => onboardingCompleted,
      );
      await tester.pumpWidget(
        MaterialApp.router(
          theme: MonAITheme.light(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();
      return router;
    }

    testWidgets('a signed-out user new to the app lands on Onboarding', (
      tester,
    ) async {
      // Arrange
      const onboardingCompleted = false;

      // Act
      final router = await pumpLaunch(
        tester,
        onboardingCompleted: onboardingCompleted,
      );

      // Assert
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.onboarding,
      );
    });

    testWidgets('a signed-out user who finished onboarding lands on Sign in', (
      tester,
    ) async {
      // Arrange
      const onboardingCompleted = true;

      // Act
      final router = await pumpLaunch(
        tester,
        onboardingCompleted: onboardingCompleted,
      );

      // Assert
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.signIn,
      );
    });
  });

  group('email hand-off', () {
    test('carries the email as a query parameter', () {
      // Arrange
      const email = 'ana+1@b.co';

      // Act
      final location = AppRoutes.registerWith(email: email);

      // Assert
      expect(Uri.parse(location).queryParameters['email'], email);
      expect(Uri.parse(location).path, AppRoutes.register);
    });

    test('an empty email adds no parameter', () {
      // Arrange
      // (no email typed)

      // Act
      final location = AppRoutes.signInWith();

      // Assert
      expect(location, AppRoutes.signIn);
    });
  });
}
