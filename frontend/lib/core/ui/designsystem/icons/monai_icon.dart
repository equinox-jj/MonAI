import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';

/// Draws a [MonAIIconData] SVG tinted with [color].
///
/// Like [Icon], [size] and [color] default to the ambient [IconTheme], so an
/// icon inside a button picks up the button's foreground color.
class MonAIIcon extends StatelessWidget {
  /// Creates an icon. Leave [semanticLabel] null for decorative icons.
  const MonAIIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  /// The icon to draw.
  final MonAIIconData icon;

  /// The square size; defaults to the [IconTheme] size, then 24.
  final double? size;

  /// The tint; defaults to the [IconTheme] color.
  final Color? color;

  /// Read by screen readers. Null hides the icon from them.
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
