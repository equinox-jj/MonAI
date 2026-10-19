import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_event.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_state.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._completeOnboarding) : super(const OnboardingState()) {
    on<OnboardingNextPressed>((_, emit) => _goTo(state.page + 1, emit));
    on<OnboardingBackPressed>((_, emit) => _goTo(state.page - 1, emit));
    on<OnboardingPageChanged>((event, emit) => _goTo(event.page, emit));
    on<OnboardingExitPressed>(_onExit);
  }

  final CompleteOnboardingUseCase _completeOnboarding;

  // Set by the first way out; navigation replaces the screen, so a second
  // tap must not navigate again.
  bool _finishing = false;

  void _goTo(int target, Emitter<OnboardingState> emit) {
    final page = target.clamp(0, OnboardingStep.values.length - 1);
    emit(state.copyWith(page: page));
  }

  /// Leaving onboarding is final: the flag is saved first, so later launches
  /// start on Sign in. A failed save still lets the user through; at worst
  /// they see onboarding again.
  Future<void> _onExit(
    OnboardingExitPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    if (_finishing) return;
    _finishing = true;
    await _completeOnboarding(const NoParams());
    emit(state.copyWith(exit: event.exit));
  }
}
