import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';

class _MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

void main() {
  late _MockCompleteOnboardingUseCase completeOnboarding;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    completeOnboarding = _MockCompleteOnboardingUseCase();
    when(() => completeOnboarding(any()))
        .thenAnswer((_) async => const Right(unit));
    sl.registerFactory(() => OnboardingBloc(completeOnboarding));
  });

  tearDown(sl.reset);

  Future<void> pumpOnboarding(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: MonAITheme.light(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: createAppRouter(initialLocation: AppRoutes.onboarding),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the first page offers Next and Skip', (tester) async {
    // Arrange
    await pumpOnboarding(tester);

    // Act
    final title = find.text('Every rupiah, every wallet, in seconds.');

    // Assert
    expect(title, findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Back'), findsNothing);
  });

  testWidgets('Next shows the wallets page with Back and Next', (tester) async {
    // Arrange
    await pumpOnboarding(tester);

    // Act
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('All your wallets, one total.'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    // The hero's Skip on the wallets page.
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('swiping to the last page shows the account buttons', (
    tester,
  ) async {
    // Arrange
    await pumpOnboarding(tester);

    // Act
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('See where it went. Stay on budget.'), findsOneWidget);
    expect(find.text('Create free account'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });

  testWidgets('Skip saves the flag and opens Register', (tester) async {
    // Arrange
    await pumpOnboarding(tester);

    // Act
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Assert
    verify(() => completeOnboarding(any())).called(1);
    expect(find.text('Register Page'), findsOneWidget);
  });

  testWidgets('I already have an account opens Sign in', (tester) async {
    // Arrange
    await pumpOnboarding(tester);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next').last);
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('I already have an account'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Sign In Page'), findsOneWidget);
  });
}
