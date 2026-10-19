part of 'onboarding_bloc.dart';

@freezed
sealed class OnboardingEvent with _$OnboardingEvent {
  /// Next page.
  const factory OnboardingEvent.nextPressed() = _NextPressed;

  /// Previous page, from the Back button or system back.
  const factory OnboardingEvent.backPressed() = _BackPressed;

  /// The pager moved to [page], e.g. after a swipe.
  const factory OnboardingEvent.pageChanged(int page) = _PageChanged;

  /// Leave onboarding through Skip, Create account or Sign in.
  const factory OnboardingEvent.exitPressed(OnboardingExit exit) = _ExitPressed;
}
