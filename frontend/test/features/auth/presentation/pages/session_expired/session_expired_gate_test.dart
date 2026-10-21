import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/cubit/session_expired_cubit.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/session_expired_gate.dart';

void main() {
  late SessionManager sessionManager;

  setUp(() {
    sessionManager = SessionManager()..signedIn();
    sl.registerFactory(() => SessionExpiredCubit(sessionManager));
  });

  tearDown(() async {
    await sl.reset();
    sessionManager.dispose();
  });

  /// The gate above the navigator, as `MaterialApp.router(builder:)` puts it.
  Future<void> pumpGate(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      theme: MonAITheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      builder: (_, child) => SessionExpiredGate(child: child!),
      home: const Scaffold(body: Text('app')),
    ),
  );

  testWidgets('tapping outside the password-changed dialog keeps it', (
    tester,
  ) async {
    // Arrange
    await pumpGate(tester);
    sessionManager.notifyPasswordChanged();
    await tester.pump();

    // Act
    await tester.tapAt(const Offset(4, 4));
    await tester.pump();

    // Assert
    expect(tester.takeException(), isNull);
    expect(find.text('Password changed'), findsOneWidget);
  });

  testWidgets('tapping outside the session-expired dialog keeps it', (
    tester,
  ) async {
    // Arrange
    await pumpGate(tester);
    sessionManager.notifyExpired();
    await tester.pump();

    // Act
    await tester.tapAt(const Offset(4, 4));
    await tester.pump();

    // Assert
    expect(tester.takeException(), isNull);
    expect(find.text('Session expired'), findsOneWidget);
  });
}
