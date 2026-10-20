import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';

/// Placeholder blocks in the dashboard's shape while the first load runs.
/// Read out as one label.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Clipped rather than scrolled, so a short screen cuts the last blocks
    // instead of squeezing them.
    return Semantics(
      label: context.l10n.homeLoading,
      excludeSemantics: true,
      child: const ClipRect(
        child: OverflowBox(
          alignment: .topCenter,
          maxHeight: double.infinity,
          child: Padding(
            padding: .symmetric(vertical: MonAISpacing.screenTop),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: MonAISpacing.sectionGap,
              children: [
                _Padded(child: _HeaderSkeleton()),
                _Padded(child: _BalanceSkeleton()),
                _Padded(
                  child: MonAISkeleton(
                    height: MonAISizes.quickAddField,
                    borderRadius: MonAIRadius.fullAll,
                  ),
                ),
                _WalletsSkeleton(),
                _Padded(child: _BudgetSkeleton()),
                _Padded(child: _RecentSkeleton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Padded extends StatelessWidget {
  const _Padded({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: MonAISpacing.screenHorizontal),
      child: child,
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: MonAISpacing.x3,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x2,
            children: [
              MonAISkeleton(height: 14, width: 110),
              MonAISkeleton(height: 22, width: 90),
            ],
          ),
        ),
        _CircleSkeleton(),
        _CircleSkeleton(),
      ],
    );
  }
}

class _CircleSkeleton extends StatelessWidget {
  const _CircleSkeleton({this.size = MonAISizes.touchTarget});

  final double size;

  @override
  Widget build(BuildContext context) {
    return MonAISkeleton(
      height: size,
      width: size,
      borderRadius: MonAIRadius.fullAll,
    );
  }
}

class _BalanceSkeleton extends StatelessWidget {
  const _BalanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return const MonAIGradientCard(
      elevated: false,
      decorated: false,
      child: Column(
        crossAxisAlignment: .start,
        spacing: MonAISpacing.x4,
        children: [
          MonAISkeleton(height: 14, width: 150, onGradient: true),
          MonAISkeleton(
            height: 36,
            width: 180,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            onGradient: true,
          ),
          Row(
            spacing: MonAISpacing.x2,
            children: [
              Expanded(child: _TileSkeleton()),
              Expanded(child: _TileSkeleton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const MonAISkeleton(
      height: 52,
      borderRadius: MonAIRadius.lgAll,
      onGradient: true,
    );
  }
}

class _WalletsSkeleton extends StatelessWidget {
  const _WalletsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.sectionContentGap,
      children: [
        _Padded(child: MonAISkeleton(height: 20, width: 80)),
        SingleChildScrollView(
          scrollDirection: .horizontal,
          physics: NeverScrollableScrollPhysics(),
          padding: .only(left: MonAISpacing.screenHorizontal),
          child: Row(
            spacing: MonAISpacing.x3,
            children: [_WalletSkeleton(), _WalletSkeleton()],
          ),
        ),
      ],
    );
  }
}

class _WalletSkeleton extends StatelessWidget {
  const _WalletSkeleton();

  @override
  Widget build(BuildContext context) {
    return const MonAISkeleton(
      height: MonAISizes.walletCardHeight,
      width: MonAISizes.walletCardWidth,
      borderRadius: MonAIRadius.lgAll,
    );
  }
}

class _BudgetSkeleton extends StatelessWidget {
  const _BudgetSkeleton();

  @override
  Widget build(BuildContext context) {
    return const MonAICard(
      child: Column(
        crossAxisAlignment: .start,
        spacing: MonAISpacing.x3,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              MonAISkeleton(height: 16, width: 120),
              MonAISkeleton(height: 16, width: 40),
            ],
          ),
          MonAISkeleton(height: MonAISizes.progressTrack),
          MonAISkeleton(height: 12, width: 200),
        ],
      ),
    );
  }
}

class _RecentSkeleton extends StatelessWidget {
  const _RecentSkeleton();

  @override
  Widget build(BuildContext context) {
    return const MonAICard(
      padding: .zero,
      child: Column(
        children: [
          _RowSkeleton(titleFraction: 0.6, metaFraction: 0.4, amountWidth: 70),
          MonAIDivider(),
          _RowSkeleton(titleFraction: 0.5, metaFraction: 0.35, amountWidth: 60),
        ],
      ),
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton({
    required this.titleFraction,
    required this.metaFraction,
    required this.amountWidth,
  });

  final double titleFraction;
  final double metaFraction;
  final double amountWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(
        horizontal: MonAISpacing.x4,
        vertical: MonAISpacing.x3_5,
      ),
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          const _CircleSkeleton(size: MonAISizes.avatarMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: MonAISpacing.x1_5,
              children: [
                FractionallySizedBox(
                  widthFactor: titleFraction,
                  child: const MonAISkeleton(height: 14),
                ),
                FractionallySizedBox(
                  widthFactor: metaFraction,
                  child: const MonAISkeleton(height: 10),
                ),
              ],
            ),
          ),
          MonAISkeleton(height: 14, width: amountWidth),
        ],
      ),
    );
  }
}
