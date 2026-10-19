import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/home/presentation/pages/home/home_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/wallets_page.dart';

void main() {
  Future<void> pumpDashboard(WidgetTester tester) async {
    final sessionManager = SessionManager()..signedIn();
    addTearDown(sessionManager.dispose);
    final router = createAppRouter(
      sessionManager: sessionManager,
      isOnboardingCompleted: () async => true,
      initialLocation: AppRoutes.home,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the Home tab', (tester) async {
    // Arrange
    await pumpDashboard(tester);

    // Act
    final home = find.byType(HomePage);

    // Assert
    expect(home, findsOneWidget);
  });

  testWidgets('tapping a destination shows its tab', (tester) async {
    // Arrange
    await pumpDashboard(tester);

    // Act
    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(WalletsPage), findsOneWidget);
  });
}
