import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';
import 'package:monai/core/model/budget_status.dart';

extension BudgetStatusColor on BudgetStatus {
  Color color(MonAIColors c) => switch (this) {
    .ok => c.accent,
    .warning => c.warning,
    .exceeded => c.error,
  };
}

class MonAIBudgetRemaining extends StatelessWidget {
  const MonAIBudgetRemaining({
    required this.text,
    required this.status,
    super.key,
  });

  final String text;
  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (color, icon) = switch (status) {
      .ok => (c.textSecondary, null),
      .warning => (c.warning, MonAIIcons.warning),
      .exceeded => (c.error, MonAIIcons.error),
    };
    return Row(
      mainAxisSize: .min,
      spacing: MonAISpacing.x1,
      children: [
        if (icon != null)
          MonAIIcon(icon, size: MonAISizes.iconSm, color: color),
        Flexible(
          child: Text(
            text,
            style: context.textStyles.bodyCompact
                .withWeight(.w600)
                .copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class MonAIBudgetPromptCard extends StatelessWidget {
  const MonAIBudgetPromptCard({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
    super.key,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(color: c.primaryContainerBorder),
      child: Material(
        color: c.surface,
        borderRadius: MonAIRadius.lgAll,
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .symmetric(
              horizontal: MonAISpacing.x4,
              vertical: MonAISpacing.x3_5,
            ),
            child: Row(
              spacing: MonAISpacing.x3,
              children: [
                Container(
                  width: MonAISizes.avatarMedium,
                  height: MonAISizes.avatarMedium,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: c.primaryContainer,
                    shape: .circle,
                  ),
                  child: MonAIIcon(
                    MonAIIcons.savings,
                    size: MonAISizes.iconLg,
                    color: c.accent,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: t.titleSmall
                            ?.withWeight(.w600)
                            .copyWith(color: c.textPrimary),
                      ),
                      Text(
                        body,
                        style: t.bodySmall?.copyWith(color: c.textTertiary),
                      ),
                    ],
                  ),
                ),
                Text(
                  actionLabel,
                  style: t.labelLarge?.copyWith(color: c.accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  static const _dash = 4.0;
  static const _space = 3.0;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const half = MonAISizes.border / 2;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            half,
            half,
            size.width - half * 2,
            size.height - half * 2,
          ),
          const Radius.circular(MonAIRadius.lg),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = .stroke
      ..strokeWidth = MonAISizes.border;
    for (final metric in outline.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + _dash), paint);
        distance += _dash + _space;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
