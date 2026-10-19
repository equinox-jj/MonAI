part of 'onboarding_bloc.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    /// The current page, from 0.
    @Default(0) int page,

    /// [UiStatus.loading] while saving the onboarding flag, then
    /// [UiStatus.success] once the user may leave.
    @Default(UiStatus.initial) UiStatus status,

    /// Where to go once [status] is success; the screen navigates on it.
    OnboardingExit? exit,
  }) = _OnboardingState;
}

extension OnboardingStateX on OnboardingState {
  int get pageCount => OnboardingStep.values.length;

  OnboardingStep get step => OnboardingStep.values[page];
}
