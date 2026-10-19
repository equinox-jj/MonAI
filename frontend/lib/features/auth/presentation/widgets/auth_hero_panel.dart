import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/auth/presentation/widgets/auth_sample_cards.dart';

const _heroPadding = 64.0;
const _headlineMaxWidth = 460.0;
const _samplesMaxWidth = 420.0;
const _brandTileSize = 40.0;

/// The tablet hero headline is larger than any type token (45/52 in the
/// design).
const _headlineFontSize = 45.0;
const _headlineLineHeight = 52.0;

/// Left half of the expanded auth layout. Decorative, so it is hidden from
/// screen readers.
class AuthHeroPanel extends StatelessWidget {
  const AuthHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRect(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: context.colors.heroGradient),
          child: const Stack(
            fit: .expand,
            children: [
              _HeroCircle(right: -120, top: -120, size: 420, alpha: 0.07),
              _HeroCircle(left: -80, bottom: -140, size: 360, alpha: 0.05),
              _HeroContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCircle extends StatelessWidget {
  const _HeroCircle({
    required this.size,
    required this.alpha,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  final double size;
  final double alpha;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}

/// The brand, headline and sample cards, scaled down when the window is too
/// short to fit them.
class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: .centerLeft,
        child: FittedBox(
          fit: .scaleDown,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Padding(
              padding: const .all(_heroPadding),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                spacing: MonAISpacing.x6,
                children: [
                  Row(
                    spacing: MonAISpacing.x3,
                    children: [
                      Container(
                        width: _brandTileSize,
                        height: _brandTileSize,
                        alignment: .center,
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: MonAIRadius.mdAll,
                        ),
                        child: MonAIIcon(
                          MonAIIcons.accountBalanceWallet,
                          color: c.accent,
                        ),
                      ),
                      Text(
                        l10n.authBrandName,
                        style: context.textTheme.titleLarge
                            ?.withWeight(.w700)
                            .copyWith(color: c.onPrimary),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _headlineMaxWidth,
                    ),
                    child: Text(
                      l10n.authHeroTitle,
                      style: context.textTheme.displayLarge?.copyWith(
                        fontSize: _headlineFontSize,
                        height: _headlineLineHeight / _headlineFontSize,
                        color: c.onPrimary,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _samplesMaxWidth,
                    ),
                    child: const Column(
                      spacing: MonAISpacing.x3,
                      children: [
                        AuthSamplePromptCard(),
                        AuthSampleExpenseCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
