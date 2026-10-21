import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/auth/domain/usecase/register_usecase.dart';
import 'package:monai/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:monai/features/auth/presentation/pages/register/register_page.dart';

class _MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late _MockRegisterUseCase register;

  setUpAll(
    () => registerFallbackValue(
      const RegisterParams(name: '', email: '', password: ''),
    ),
  );

  setUp(() {
    register = _MockRegisterUseCase();
    sl.registerFactory(() => RegisterBloc(register));
  });

  tearDown(sl.reset);

  Future<void> pumpRegister(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: MonAITheme.light(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const RegisterPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the length hint and the setup note', (tester) async {
    // Arrange
    await pumpRegister(tester);

    // Act
    final hint = find.text('At least 8 characters');

    // Assert
    expect(find.text('Create your account'), findsOneWidget);
    expect(hint, findsOneWidget);
    expect(find.textContaining("We'll set up a Cash wallet"), findsOneWidget);
  });

  testWidgets('a taken email offers Sign in instead', (tester) async {
    // Arrange
    when(
      () => register(any()),
    ).thenAnswer((_) async => const Left(Failure.conflict(code: 'conflict')));
    await pumpRegister(tester);

    // Act
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    // Assert
    // Message and link are one text node, so screen readers read both.
    expect(
      find.text(
        'This email already has an account. Sign in instead',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });
}
