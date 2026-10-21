import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';

extension OnboardingStateX on OnboardingState {
  int get pageCount => OnboardingStep.values.length;

  OnboardingStep get step => OnboardingStep.values[page];
}
