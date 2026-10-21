import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/theme/monai_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

/// Shortcuts to the MonAI theme from a [BuildContext].
extension MonAIThemeX on BuildContext {
  /// The semantic colors of the current theme.
  MonAIColors get colors =>
      Theme.of(this).extension<MonAIColors>() ?? MonAIColors.light;

  /// The Material text styles (the design's type scale).
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The design's extra text styles (amounts, overline, compact body).
  MonAITextStyles get textStyles =>
      Theme.of(this).extension<MonAITextStyles>() ?? MonAITextStyles.standard;
}
