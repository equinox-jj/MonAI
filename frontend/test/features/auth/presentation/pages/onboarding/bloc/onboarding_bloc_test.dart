import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_event.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_state.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';

class _MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

void main() {
  late _MockCompleteOnboardingUseCase completeOnboarding;
  late OnboardingBloc bloc;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    completeOnboarding = _MockCompleteOnboardingUseCase();
    when(() => completeOnboarding(any()))
        .thenAnswer((_) async => const Right(unit));
    bloc = OnboardingBloc(completeOnboarding);
  });

  tearDown(() => bloc.close());

  test('starts on the first page', () {
    // Arrange
    // (the bloc from setUp)

    // Act
    final state = bloc.state;

    // Assert
    expect(state, const OnboardingState());
    expect(state.step, OnboardingStep.capture);
    expect(state.pageCount, 3);
  });

  test('Next moves forward and stays on the last page', () async {
    // Arrange
    final expectation = expectLater(
      bloc.stream.map((s) => s.page),
      emitsInOrder([1, 2, emitsDone]),
    );

    // Act
    bloc
      ..add(const OnboardingNextPressed())
      ..add(const OnboardingNextPressed())
      ..add(const OnboardingNextPressed());
    await pumpEventQueue();
    await bloc.close();

    // Assert
    await expectation;
  });

  test('Back moves backward and stays on the first page', () async {
    // Arrange
    bloc.add(const OnboardingPageChanged(1));
    final expectation = expectLater(
      bloc.stream.map((s) => s.page),
      emitsInOrder([1, 0, emitsDone]),
    );

    // Act
    bloc
      ..add(const OnboardingBackPressed())
      ..add(const OnboardingBackPressed());
    await pumpEventQueue();
    await bloc.close();

    // Assert
    await expectation;
  });

  test('a swipe moves to that page, clamped to the range', () async {
    // Arrange
    final expectation = expectLater(
      bloc.stream.map((s) => s.page),
      emitsInOrder([2, 0]),
    );

    // Act
    bloc
      ..add(const OnboardingPageChanged(5))
      ..add(const OnboardingPageChanged(-1));

    // Assert
    await expectation;
  });

  test('exiting saves the flag, then sets the exit', () async {
    // Arrange
    final expectation = expectLater(
      bloc.stream,
      emits(const OnboardingState(exit: OnboardingExit.register)),
    );

    // Act
    bloc.add(const OnboardingExitPressed(OnboardingExit.register));

    // Assert
    await expectation;
    verify(() => completeOnboarding(const NoParams())).called(1);
  });

  test('Sign in exits to sign in', () async {
    // Arrange
    final expectation = expectLater(
      bloc.stream.map((s) => s.exit),
      emits(OnboardingExit.signIn),
    );

    // Act
    bloc.add(const OnboardingExitPressed(OnboardingExit.signIn));

    // Assert
    await expectation;
  });

  test('a second exit is ignored', () async {
    // Arrange
    final states = <OnboardingState>[];
    final subscription = bloc.stream.listen(states.add);

    // Act
    bloc
      ..add(const OnboardingExitPressed(OnboardingExit.register))
      ..add(const OnboardingExitPressed(OnboardingExit.signIn));
    await pumpEventQueue();

    // Assert
    expect(states, const [OnboardingState(exit: OnboardingExit.register)]);
    verify(() => completeOnboarding(any())).called(1);
    await subscription.cancel();
  });

  test('still exits when saving the flag fails', () async {
    // Arrange
    when(() => completeOnboarding(any()))
        .thenAnswer((_) async => const Left(Failure.cache()));
    final expectation = expectLater(
      bloc.stream.map((s) => s.exit),
      emits(OnboardingExit.register),
    );

    // Act
    bloc.add(const OnboardingExitPressed(OnboardingExit.register));

    // Assert
    await expectation;
  });
}
