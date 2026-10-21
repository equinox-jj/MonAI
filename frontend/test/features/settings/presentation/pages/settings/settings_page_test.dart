import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/presentation/pages/settings/settings_page.dart';

import '../../../../../helpers/settings_fakes.dart';

const _admin = SettingsOverview(
  profile: SettingsProfile(
    name: 'Joshua Pardede',
    email: 'joshua@example.com',
    initials: 'JP',
    roleBadge: 'Admin',
  ),
  budgetLimit: 3000000,
  categoryCount: 10,
  walletCount: 4,
  canManageProviders: true,
);

void main() {
  late SettingsFakes fakes;

  setUp(() => fakes = SettingsFakes()..register());

  tearDown(() async {
    await fakes.appSettings.close();
    await sl.reset();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      BlocProvider.value(
        value: fakes.appSettings,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          theme: MonAITheme.light(),
          home: const Scaffold(body: SettingsPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a regular user sees every group but Admin', (tester) async {
    // Arrange
    // (the fakes cache a regular user without a budget)

    // Act
    await pumpSettings(tester);

    // Assert
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('ana@monai.id'), findsOneWidget);
    expect(find.text('Not set'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
    expect(find.text('Manage payment providers'), findsNothing);
  });

  testWidgets('an admin sees the role badge, the budget and Admin', (
    tester,
  ) async {
    // Arrange
    fakes.cacheHolds(_admin);

    // Act
    await pumpSettings(tester);

    // Assert
    expect(find.widgetWithText(MonAITag, 'ADMIN'), findsOneWidget);
    expect(find.text('Rp 3 jt'), findsOneWidget);
    expect(find.text('Manage payment providers'), findsOneWidget);
  });

  testWidgets('picking a theme switches the app and closes the sheet', (
    tester,
  ) async {
    // Arrange
    await pumpSettings(tester);
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    // Assert
    expect(fakes.appSettings.state.themeMode, AppThemeMode.dark);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Done'), findsNothing);
    verify(() => fakes.setThemeMode(AppThemeMode.dark)).called(1);
  });

  testWidgets('picking a language switches the app', (tester) async {
    // Arrange
    await pumpSettings(tester);
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Bahasa Indonesia'));
    await tester.pumpAndSettle();

    // Assert
    expect(fakes.appSettings.state.language, AppLanguage.indonesian);
    verify(() => fakes.setLanguage(AppLanguage.indonesian)).called(1);
  });

  testWidgets('signing out asks first, then signs out', (tester) async {
    // Arrange
    await pumpSettings(tester);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.widgetWithText(MonAIButton, 'Sign out'));
    await tester.pumpAndSettle();

    // Assert
    verify(() => fakes.logout(const NoParams())).called(1);
    verifyNever(() => fakes.logoutAllDevices(any()));
  });

  testWidgets('cancelling the dialog keeps the session', (tester) async {
    // Arrange
    await pumpSettings(tester);
    await tester.tap(find.text('Sign out of all devices'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Sign out of all devices?'), findsNothing);
    verifyNever(() => fakes.logoutAllDevices(any()));
  });

  testWidgets('a sign-out that fails offline says so', (tester) async {
    // Arrange
    when(() => fakes.logoutAllDevices(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    await pumpSettings(tester);
    await tester.tap(find.text('Sign out of all devices'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(
      find.widgetWithText(MonAIButton, 'Sign out of all devices'),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(
      find.text("You're offline. Connect to the internet and try again."),
      findsOneWidget,
    );
  });
}
