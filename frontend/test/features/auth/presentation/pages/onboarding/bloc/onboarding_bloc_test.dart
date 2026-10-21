import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_state_extension.dart';
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
        .thenAnswer((_) async => const Right(true));
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
      ..add(const OnboardingEvent.nextPressed())
      ..add(const OnboardingEvent.nextPressed())
      ..add(const OnboardingEvent.nextPressed());
    await pumpEventQueue();
    await bloc.close();

    // Assert
    await expectation;
  });

  test('Back moves backward and stays on the first page', () async {
    // Arrange
    bloc.add(const OnboardingEvent.pageChanged(1));
    final expectation = expectLater(
      bloc.stream.map((s) => s.page),
      emitsInOrder([1, 0, emitsDone]),
    );

    // Act
    bloc
      ..add(const OnboardingEvent.backPressed())
      ..add(const OnboardingEvent.backPressed());
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
      ..add(const OnboardingEvent.pageChanged(5))
      ..add(const OnboardingEvent.pageChanged(-1));

    // Assert
    await expectation;
  });

  test(
    'exiting shows loading while saving the flag, then sets the exit',
    () async {
      // Arrange
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder(const [
          OnboardingState(status: UiStatus.loading),
          OnboardingState(
            status: UiStatus.success,
            exit: OnboardingExit.register,
          ),
        ]),
      );

      // Act
      bloc.add(const OnboardingEvent.exitPressed(OnboardingExit.register));

      // Assert
      await expectation;
      verify(() => completeOnboarding(const NoParams())).called(1);
    },
  );

  test('Sign in exits to sign in', () async {
    // Arrange
    final expectation = expectLater(
      bloc.stream.map((s) => s.exit),
      emitsThrough(OnboardingExit.signIn),
    );

    // Act
    bloc.add(const OnboardingEvent.exitPressed(OnboardingExit.signIn));

    // Assert
    await expectation;
  });

  test('a second exit is ignored', () async {
    // Arrange
    final states = <OnboardingState>[];
    final subscription = bloc.stream.listen(states.add);

    // Act
    bloc
      ..add(const OnboardingEvent.exitPressed(OnboardingExit.register))
      ..add(const OnboardingEvent.exitPressed(OnboardingExit.signIn));
    await pumpEventQueue();

    // Assert
    expect(states, const [
      OnboardingState(status: UiStatus.loading),
      OnboardingState(status: UiStatus.success, exit: OnboardingExit.register),
    ]);
    verify(() => completeOnboarding(any())).called(1);
    await subscription.cancel();
  });

  test('still exits when saving the flag fails', () async {
    // Arrange
    when(() => completeOnboarding(any()))
        .thenAnswer((_) async => const Left(Failure.cache()));
    final expectation = expectLater(
      bloc.stream.map((s) => s.exit),
      emitsThrough(OnboardingExit.register),
    );

    // Act
    bloc.add(const OnboardingEvent.exitPressed(OnboardingExit.register));

    // Assert
    await expectation;
  });
}
