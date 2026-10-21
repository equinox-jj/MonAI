import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/components/monai_feedback.dart';
import 'package:monai/core/ui/designsystem/components/monai_surfaces.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

class MonAIStateMessage extends StatelessWidget {
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

  final MonAIIconData icon;
  final String title;
  final String message;
  final MonAIAlertTone tone;
  final String? actionLabel;
  final MonAIIconData? actionIcon;
  final VoidCallback? onAction;
  final bool actionLoading;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
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

class MonAISkeleton extends StatefulWidget {
  const MonAISkeleton({
    required this.height,
    super.key,
    this.width,
    this.borderRadius = MonAIRadius.xsAll,
    this.onGradient = false,
  });

  final double height;
  final double? width;
  final BorderRadius borderRadius;
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

class MonAIProgressBar extends StatelessWidget {
  const MonAIProgressBar({
    required this.progress,
    super.key,
    this.color,
    this.trackColor,
  });

  final double progress;
  final Color? color;
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

class MonAIPageIndicator extends StatelessWidget {
  const MonAIPageIndicator({
    required this.pageCount,
    required this.currentPage,
    super.key,
  });

  final int pageCount;
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
