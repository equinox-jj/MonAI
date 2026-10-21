import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';

class MonAIMonthSwitcher extends StatelessWidget {
  const MonAIMonthSwitcher({
    required this.label,
    required this.previousTooltip,
    required this.nextTooltip,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final String label;
  final String previousTooltip;
  final String nextTooltip;

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const .all(MonAISpacing.x0_5),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: MonAIRadius.fullAll,
      ),
      child: Row(
        children: [
          MonAIIconButton(
            icon: MonAIIcons.chevronLeft,
            tooltip: previousTooltip,
            onPressed: onPrevious,
          ),
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                label,
                textAlign: .center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: c.textPrimary,
                ),
              ),
            ),
          ),
          MonAIIconButton(
            icon: MonAIIcons.chevronRight,
            tooltip: nextTooltip,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
