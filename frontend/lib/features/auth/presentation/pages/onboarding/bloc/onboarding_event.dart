import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';

sealed class OnboardingEvent {
  const OnboardingEvent();
}

/// Next page.
final class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

/// Previous page, from the Back button or system back.
final class OnboardingBackPressed extends OnboardingEvent {
  const OnboardingBackPressed();
}

/// The pager moved to [page], e.g. after a swipe.
final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.page);

  final int page;
}

/// Leave onboarding through Skip, Create account or Sign in.
final class OnboardingExitPressed extends OnboardingEvent {
  const OnboardingExitPressed(this.exit);

  final OnboardingExit exit;
}
