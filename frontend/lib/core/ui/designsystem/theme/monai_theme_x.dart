import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/theme/monai_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

extension MonAIThemeX on BuildContext {
  MonAIColors get colors =>
      Theme.of(this).extension<MonAIColors>() ?? MonAIColors.light;

  TextTheme get textTheme => Theme.of(this).textTheme;

  MonAITextStyles get textStyles =>
      Theme.of(this).extension<MonAITextStyles>() ?? MonAITextStyles.standard;
}
