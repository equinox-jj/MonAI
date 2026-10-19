import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/components/monai_button.dart';
import 'package:monai/core/designsystem/components/monai_feedback.dart';
import 'package:monai/core/designsystem/components/monai_surfaces.dart';
import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// Centered icon, title, message and actions for empty and error states.
///
/// [MonAIAlertTone.error] gives the red icon circle; any other tone is
/// indigo. [footnote] is a small gray line under the actions, e.g.
/// "Error code: internal_error".
class MonAIStateMessage extends StatelessWidget {
  /// Creates a state message.
  const MonAIStateMessage({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.tone = MonAIAlertTone.info,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.actionLoading = false,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.footnote,
  });

  /// The icon in the circle.
  final MonAIIconData icon;

  /// The heading.
  final String title;

  /// The explanation.
  final String message;

  /// Red for errors, indigo otherwise.
  final MonAIAlertTone tone;

  /// The main button's label; none when null.
  final String? actionLabel;

  /// An icon on the main button.
  final MonAIIconData? actionIcon;

  /// The main button's action.
  final VoidCallback? onAction;

  /// Shows a spinner on the main button ("Trying…").
  final bool actionLoading;

  /// A link under the main button.
  final String? secondaryActionLabel;

  /// The link's action.
  final VoidCallback? onSecondaryAction;

  /// A small gray line at the bottom.
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final isError = tone == .error;
    return Semantics(
      liveRegion: isError,
      child: Column(
        mainAxisSize: .min,
        spacing: MonAISpacing.x3,
        children: [
          Container(
            width: MonAISizes.stateIcon,
            height: MonAISizes.stateIcon,
            alignment: .center,
            decoration: BoxDecoration(
              color: isError ? c.errorContainer : c.primaryContainer,
              shape: .circle,
            ),
            child: MonAIIcon(
              icon,
              size: MonAISizes.iconXxl,
              color: isError ? c.error : c.accent,
            ),
          ),
          Text(
            title,
            style: t.titleMedium?.copyWith(color: c.textPrimary),
            textAlign: .center,
          ),
          Text(
            message,
            style: t.bodyMedium?.copyWith(color: c.textSecondary),
            textAlign: .center,
          ),
          if (actionLabel case final label?)
            Padding(
              padding: const .only(top: MonAISpacing.x1),
              child: MonAIButton(
                label: label,
                onPressed: onAction,
                size: .medium,
                leadingIcon: actionIcon,
                loading: actionLoading,
              ),
            ),
          if (secondaryActionLabel case final label?)
            MonAITextLink(
              label: label,
              onPressed: onSecondaryAction,
              style: context.textStyles.bodyCompact.withWeight(.w600),
            ),
          if (footnote case final footnote?)
            Text(footnote, style: t.bodySmall?.copyWith(color: c.textDisabled)),
        ],
      ),
    );
  }
}

/// A shimmering placeholder block. Leave [width] null to fill the available
/// width; use [onGradient] inside a [MonAIGradientCard].
class MonAISkeleton extends StatefulWidget {
  /// Creates a skeleton block.
  const MonAISkeleton({
    required this.height,
    super.key,
    this.width,
    this.borderRadius = MonAIRadius.xsAll,
    this.onGradient = false,
  });

  /// The block's height.
  final double height;

  /// The block's width; fills the parent when null.
  final double? width;

  /// Corner radius; pass [MonAIRadius.fullAll] for circles and pills.
  final BorderRadius borderRadius;

  /// Uses translucent white, for placeholders on a gradient.
  final bool onGradient;

  @override
  State<MonAISkeleton> createState() => _MonAISkeletonState();
}

class _MonAISkeletonState extends State<MonAISkeleton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (base, highlight) = widget.onGradient
        ? (
            Colors.white.withValues(alpha: 0.14),
            Colors.white.withValues(alpha: 0.28),
          )
        : c.isDark
        ? (c.surfaceKey, c.borderStrong)
        : (c.surfaceSunken, c.border);
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            // Slides a highlight band from left to right across the block.
            final x = _controller.value * 3 - 1.5;
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                gradient: LinearGradient(
                  begin: Alignment(x - 1, 0),
                  end: Alignment(x + 1, 0),
                  colors: [base, highlight, base],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 8 rounded progress bar, e.g. budget used. [progress] is clamped to 0..1.
class MonAIProgressBar extends StatelessWidget {
  /// Creates a progress bar.
  const MonAIProgressBar({
    required this.progress,
    super.key,
    this.color,
    this.trackColor,
  });

  /// 0 to 1.
  final double progress;

  /// Fill color; defaults to `accent`.
  final Color? color;

  /// Track color; defaults to `surfaceSunken`.
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: MonAISizes.progressTrack,
      decoration: BoxDecoration(
        color: trackColor ?? c.surfaceSunken,
        borderRadius: MonAIRadius.xsAll,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0, 1),
        heightFactor: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? c.accent,
            borderRadius: MonAIRadius.xsAll,
          ),
        ),
      ),
    );
  }
}

/// Onboarding step dots: the current step is a 24 bar. Steps animate between
/// dot and bar.
class MonAIPageIndicator extends StatelessWidget {
  /// Creates a page indicator.
  const MonAIPageIndicator({
    required this.pageCount,
    required this.currentPage,
    super.key,
  });

  /// Number of steps.
  final int pageCount;

  /// The current step, from 0.
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: .min,
      spacing: MonAISpacing.x1_5,
      children: List.generate(pageCount, (index) {
        final selected = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: selected
              ? MonAISizes.pageIndicatorActive
              : MonAISizes.pageIndicatorDot,
          height: MonAISizes.pageIndicatorDot,
          decoration: BoxDecoration(
            color: selected ? c.primary : c.borderStrong,
            borderRadius: MonAIRadius.fullAll,
          ),
        );
      }),
    );
  }
}
