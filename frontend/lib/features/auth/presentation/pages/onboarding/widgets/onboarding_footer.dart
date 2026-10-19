import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';

const _transition = Duration(milliseconds: 250);

/// The step dots and the page's actions: Skip, Back/Next, or the account
/// buttons.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      buildWhen: (previous, current) => previous.page != current.page,
      builder: (context, state) => Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x6,
        children: [
          // Fixed to the link's touch height so the pager doesn't jump when
          // the link fades out.
          SizedBox(
            height: MonAISizes.touchTarget,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Semantics(
                  label: context.l10n.onboardingStep(
                    state.page + 1,
                    state.pageCount,
                  ),
                  child: MonAIPageIndicator(
                    pageCount: state.pageCount,
                    currentPage: state.page,
                  ),
                ),
                _NextLink(visible: state.step == .capture),
              ],
            ),
          ),
          // The first page can skip ahead, the middle one steps Back/Next,
          // the last offers the account actions.
          AnimatedSwitcher(
            duration: _transition,
            child: switch (state.step) {
              .capture => const _CaptureActions(),
              .wallets => const _WalletsActions(),
              .insights => const _InsightsActions(),
            },
          ),
        ],
      ),
    );
  }
}

class _NextLink extends StatelessWidget {
  const _NextLink({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: _transition,
      child: IgnorePointer(
        ignoring: !visible,
        child: ExcludeSemantics(
          excluding: !visible,
          child: MonAITextLink(
            label: context.l10n.onboardingNext,
            trailingIcon: MonAIIcons.arrowForward,
            onPressed: () => context.read<OnboardingBloc>().add(
              const OnboardingEvent.nextPressed(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptureActions extends StatelessWidget {
  const _CaptureActions();

  @override
  Widget build(BuildContext context) {
    return MonAIButton(
      label: context.l10n.onboardingSkip,
      variant: .outlined,
      expand: true,
      onPressed: () => context.read<OnboardingBloc>().add(
        const OnboardingEvent.exitPressed(.register),
      ),
    );
  }
}

class _WalletsActions extends StatelessWidget {
  const _WalletsActions();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();
    return Row(
      spacing: MonAISpacing.x3,
      children: [
        Expanded(
          child: MonAIButton(
            label: context.l10n.onboardingBack,
            variant: .outlined,
            expand: true,
            onPressed: () => bloc.add(const OnboardingEvent.backPressed()),
          ),
        ),
        Expanded(
          child: MonAIButton(
            label: context.l10n.onboardingNext,
            trailingIcon: MonAIIcons.arrowForward,
            expand: true,
            onPressed: () => bloc.add(const OnboardingEvent.nextPressed()),
          ),
        ),
      ],
    );
  }
}

class _InsightsActions extends StatelessWidget {
  const _InsightsActions();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        MonAIButton(
          label: context.l10n.onboardingCreateAccount,
          expand: true,
          onPressed: () =>
              bloc.add(const OnboardingEvent.exitPressed(.register)),
        ),
        MonAIButton(
          label: context.l10n.onboardingSignIn,
          variant: .text,
          size: .medium,
          expand: true,
          onPressed: () => bloc.add(const OnboardingEvent.exitPressed(.signIn)),
        ),
      ],
    );
  }
}
