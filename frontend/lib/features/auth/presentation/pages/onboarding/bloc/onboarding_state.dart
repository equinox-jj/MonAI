part of 'onboarding_bloc.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int page,
    @Default(UiStatus.initial) UiStatus status,
    OnboardingExit? exit,
  }) = _OnboardingState;
}
