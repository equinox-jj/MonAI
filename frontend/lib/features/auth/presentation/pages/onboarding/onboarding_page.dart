import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/app_router.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/widgets/onboarding_footer.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/widgets/onboarding_step_content.dart';

/// Keeps the phone layout readable on tablets, where there is no separate
/// onboarding design.
const _maxContentWidth = 480.0;

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingBloc>(),
      child: const OnboardingUI(),
    );
  }
}

/// Stateful only to own the [PageController].
class OnboardingUI extends StatefulWidget {
  const OnboardingUI({super.key});

  @override
  State<OnboardingUI> createState() => _OnboardingUIState();
}

class _OnboardingUIState extends State<OnboardingUI> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, OnboardingState state) {
    if (state.exit case final exit?) {
      context.go(switch (exit) {
        .register => AppRoutes.register,
        .signIn => AppRoutes.signIn,
      });
      return;
    }
    // The bloc owns the page: buttons change it and the pager follows. A
    // swipe already sits on that page, so it is left alone mid-drag.
    if (_controller.hasClients && _controller.page?.round() != state.page) {
      _controller.animateToPage(
        state.page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.page != current.page || previous.exit != current.exit,
      listener: _onStateChanged,
      buildWhen: (previous, current) =>
          (previous.page == 0) != (current.page == 0),
      // System back steps through the pages before leaving the app.
      builder: (context, state) => PopScope(
        canPop: state.page == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) bloc.add(const OnboardingEvent.backPressed());
        },
        child: Scaffold(
          backgroundColor: context.colors.background,
          body: SafeArea(
            child: Align(
              alignment: .topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: OnboardingStep.values.length,
                        onPageChanged: (page) =>
                            bloc.add(OnboardingEvent.pageChanged(page)),
                        itemBuilder: (_, index) => OnboardingStepContent(
                          step: OnboardingStep.values[index],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: .fromLTRB(
                        MonAISpacing.screenHorizontalWide,
                        MonAISpacing.x6,
                        MonAISpacing.screenHorizontalWide,
                        MonAISpacing.x8,
                      ),
                      child: OnboardingFooter(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
