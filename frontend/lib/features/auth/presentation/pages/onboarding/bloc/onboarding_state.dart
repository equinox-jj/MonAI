import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int page,

    /// Set once the user has left onboarding; the screen navigates on it.
    OnboardingExit? exit,
  }) = _OnboardingState;

  const OnboardingState._();

  int get pageCount => OnboardingStep.values.length;

  OnboardingStep get step => OnboardingStep.values[page];
}
