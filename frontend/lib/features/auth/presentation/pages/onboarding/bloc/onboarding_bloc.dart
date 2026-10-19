import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';

part 'onboarding_bloc.freezed.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._completeOnboarding) : super(const OnboardingState()) {
    on<_NextPressed>((_, emit) => _goTo(state.page + 1, emit));
    on<_BackPressed>((_, emit) => _goTo(state.page - 1, emit));
    on<_PageChanged>((event, emit) => _goTo(event.page, emit));
    on<_ExitPressed>(_onExit);
  }

  final CompleteOnboardingUseCase _completeOnboarding;

  void _goTo(int target, Emitter<OnboardingState> emit) {
    final page = target.clamp(0, OnboardingStep.values.length - 1);
    emit(state.copyWith(page: page));
  }

  /// Leaving onboarding is final: the flag is saved first, so later launches
  /// start on Sign in. A failed save still lets the user through; at worst
  /// they see onboarding again. Navigation replaces the screen, so a second
  /// tap while leaving is ignored.
  Future<void> _onExit(
    _ExitPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.status != .initial) return;
    emit(state.copyWith(status: .loading));
    
    await _completeOnboarding(const NoParams());

    emit(state.copyWith(status: .success, exit: event.exit));
  }
}
