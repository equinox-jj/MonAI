part of 'onboarding_bloc.dart';

@freezed
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.nextPressed() = _NextPressed;
  const factory OnboardingEvent.backPressed() = _BackPressed;
  const factory OnboardingEvent.pageChanged(int page) = _PageChanged;
  const factory OnboardingEvent.exitPressed(OnboardingExit exit) = _ExitPressed;
}
