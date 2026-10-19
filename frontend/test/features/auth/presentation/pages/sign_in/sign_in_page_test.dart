import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/auth/domain/usecase/login_usecase.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:monai/features/auth/presentation/widgets/auth_hero_panel.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late _MockLoginUseCase login;

  setUpAll(
    () => registerFallbackValue(const LoginParams(email: '', password: '')),
  );

  setUp(() {
    login = _MockLoginUseCase();
    sl.registerFactory(() => SignInBloc(login));
  });

  tearDown(sl.reset);

  Future<void> pumpSignIn(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    String initialEmail = '',
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: MonAITheme.light(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SignInPage(initialEmail: initialEmail),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('starts with the email handed over from Register', (
    tester,
  ) async {
    // Arrange
    await pumpSignIn(tester, initialEmail: 'ana@b.co');

    // Act
    final email = find.text('ana@b.co');

    // Assert
    expect(find.text('Welcome back'), findsOneWidget);
    expect(email, findsOneWidget);
  });

  testWidgets('wrong credentials show the banner', (tester) async {
    // Arrange
    when(() => login(any())).thenAnswer(
      (_) async =>
          const Left(Failure.unauthorized(code: 'invalid_credentials')),
    );
    await pumpSignIn(tester);

    // Act
    await tester.enterText(find.byType(TextField).first, 'ana@b.co');
    await tester.enterText(find.byType(TextField).last, 'wrong');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    // Assert
    expect(
      find.text('Email or password is incorrect. Check them and try again.'),
      findsOneWidget,
    );
  });

  testWidgets('a field error shows under its field', (tester) async {
    // Arrange
    when(() => login(any())).thenAnswer(
      (_) async => const Left(
        Failure.validation([
          FieldError(field: 'email', code: 'required', message: 'required'),
        ]),
      ),
    );
    await pumpSignIn(tester);

    // Act
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Enter your email'), findsOneWidget);
  });

  testWidgets('a wide window shows the hero next to the form', (tester) async {
    // Arrange
    await pumpSignIn(tester, size: const Size(1280, 800));

    // Act
    final hero = find.byType(AuthHeroPanel);

    // Assert
    expect(hero, findsOneWidget);
    expect(
      find.text('Sign in to see your wallets on this tablet.'),
      findsOneWidget,
    );
  });
}
