import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';

/// The look of a [MonAIButton].
enum MonAIButtonVariant {
  /// Indigo fill. The main action on a screen.
  primary,

  /// Light indigo fill, e.g. "Scan", "Add wallet".
  tonal,

  /// Gray outline, e.g. "New wallet" next to "Done".
  outlined,

  /// No container; looks like a link.
  text,

  /// Red fill for confirming a destructive action.
  destructive,
}

/// The height of a [MonAIButton].
enum MonAIButtonSize {
  /// 56, 16sp. Full-width screen actions.
  large(MonAISizes.buttonLarge, MonAISpacing.x6, MonAISizes.iconLg, 8),

  /// 48, 14sp. State actions, sheet buttons.
  medium(MonAISizes.buttonMedium, MonAISpacing.x5, MonAISizes.iconLg, 6),

  /// 44, 14sp. Dialog buttons.
  compact(MonAISizes.touchTarget, MonAISpacing.x4, MonAISizes.iconMd, 6),

  /// 36, 12sp. Header pills like "Scan".
  small(MonAISizes.buttonSmall, MonAISpacing.x3_5, MonAISizes.iconSm, 6);

  const MonAIButtonSize(
    this.height,
    this.horizontalPadding,
    this.iconSize,
    this.iconGap,
  );

  /// The button's height.
  final double height;

  /// Padding on each side of the content.
  final double horizontalPadding;

  /// The leading/trailing icon size.
  final double iconSize;

  /// Gap between icon and label.
  final double iconGap;

  TextStyle? _textStyle(TextTheme t) => switch (this) {
    large => t.titleMedium,
    medium || compact => t.labelLarge,
    small => t.labelMedium,
  };
}

/// The design's pill button.
///
/// [loading] shows a spinner in place of [leadingIcon] and blocks taps while
/// keeping the enabled colors (the "Trying…" state on error screens). A null
/// [onPressed] disables the button.
class MonAIButton extends StatelessWidget {
  /// Creates a pill button.
  const MonAIButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = MonAIButtonVariant.primary,
    this.size = MonAIButtonSize.large,
    this.leadingIcon,
    this.trailingIcon,
    this.loading = false,
    this.expand = false,
  });

  /// The button text.
  final String label;

  /// Called on tap. Null disables the button.
  final VoidCallback? onPressed;

  /// The look.
  final MonAIButtonVariant variant;

  /// The height and text size.
  final MonAIButtonSize size;

  /// An icon before the label.
  final MonAIIconData? leadingIcon;

  /// An icon after the label, e.g. the arrow on an onboarding "Next".
  final MonAIIconData? trailingIcon;

  /// Shows a spinner and blocks taps, keeping the enabled colors.
  final bool loading;

  /// Fills the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    final (container, content) = switch (variant) {
      .primary => (c.primary, c.onPrimary),
      .tonal => (c.primaryContainer, c.onPrimaryContainer),
      .outlined => (Colors.transparent, c.iconStrong),
      .text => (Colors.transparent, c.accent),
      .destructive => (c.error, c.onPrimary),
    };
    final filled = variant != .outlined && variant != .text;
    // While loading, keep the enabled look; only a real disable greys it out.
    final looksEnabled = enabled || loading;
    final background = looksEnabled
        ? container
        : (filled ? c.disabledContainer : Colors.transparent);
    final foreground = looksEnabled ? content : c.disabledContent;
    final shape = StadiumBorder(
      side: variant == .outlined
          ? BorderSide(color: c.borderStrong)
          : BorderSide.none,
    );
    final style = size
        ._textStyle(context.textTheme)
        ?.copyWith(color: foreground);

    return Semantics(
      button: true,
      enabled: enabled && !loading,
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: size.height,
        child: Material(
          color: background,
          shape: shape,
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: MonAISizes.touchTarget,
              ),
              child: Padding(
                padding: .symmetric(horizontal: size.horizontalPadding),
                child: IconTheme.merge(
                  data: IconThemeData(color: foreground, size: size.iconSize),
                  child: _ButtonContent(
                    label: label,
                    style: style,
                    size: size,
                    foreground: foreground,
                    leadingIcon: leadingIcon,
                    trailingIcon: trailingIcon,
                    loading: loading,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.style,
    required this.size,
    required this.foreground,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.loading,
  });

  final String label;
  final TextStyle? style;
  final MonAIButtonSize size;
  final Color foreground;
  final MonAIIconData? leadingIcon;
  final MonAIIconData? trailingIcon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final leading = loading
        ? SizedBox.square(
            dimension: size.iconSize - 2,
            child: CircularProgressIndicator(
              color: foreground,
              backgroundColor: foreground.withValues(alpha: 0.35),
              strokeWidth: 2.5,
            ),
          )
        : switch (leadingIcon) {
            final icon? => MonAIIcon(icon),
            null => null,
          };
    return Row(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      spacing: size.iconGap,
      children: [
        ?leading,
        Flexible(
          child: Text(label, style: style, maxLines: 1, overflow: .ellipsis),
        ),
        if (trailingIcon case final icon?) MonAIIcon(icon),
      ],
    );
  }
}

/// The container of a [MonAIIconButton].
enum MonAIIconButtonStyle {
  /// No container. Top-bar back/close/edit.
  plain,

  /// Surface circle with a gray border. Home search button.
  surface,

  /// Light indigo circle. Scan receipt.
  tonal,
}

/// A circular icon button, 44 by default (52 for the quick-add scan button).
class MonAIIconButton extends StatelessWidget {
  /// Creates an icon button. [tooltip] is also its accessibility label.
  const MonAIIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.style = MonAIIconButtonStyle.plain,
    this.color,
    this.size = MonAISizes.touchTarget,
    this.iconSize = MonAISizes.icon,
  });

  /// The icon.
  final MonAIIconData icon;

  /// Shown on long press and read by screen readers.
  final String tooltip;

  /// Called on tap. Null disables the button.
  final VoidCallback? onPressed;

  /// The container.
  final MonAIIconButtonStyle style;

  /// Overrides the style's icon color.
  final Color? color;

  /// The circle's diameter.
  final double size;

  /// The icon's size.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (container, defaultTint) = switch (style) {
      .plain => (Colors.transparent, c.iconStrong),
      .surface => (c.surface, c.textSecondary),
      .tonal => (c.primaryContainer, c.accent),
    };
    final tint = onPressed == null ? c.textDisabled : color ?? defaultTint;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: tooltip,
        excludeSemantics: true,
        child: SizedBox.square(
          dimension: size,
          child: Material(
            color: container,
            shape: CircleBorder(
              side: style == .surface
                  ? BorderSide(color: c.border)
                  : BorderSide.none,
            ),
            clipBehavior: .antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Center(
                child: MonAIIcon(icon, size: iconSize, color: tint),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
