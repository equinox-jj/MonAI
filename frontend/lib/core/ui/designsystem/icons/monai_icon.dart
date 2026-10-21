import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';

class MonAIIcon extends StatelessWidget {
  const MonAIIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final MonAIIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final side = size ?? theme.size ?? MonAISizes.icon;
    final tint = color ?? theme.color;
    final picture = SvgPicture.asset(
      icon.assetPath,
      width: side,
      height: side,
      colorFilter: tint == null ? null : ColorFilter.mode(tint, .srcIn),
      excludeFromSemantics: true,
    );
    if (semanticLabel == null) return ExcludeSemantics(child: picture);
    return Semantics(label: semanticLabel, image: true, child: picture);
  }
}
