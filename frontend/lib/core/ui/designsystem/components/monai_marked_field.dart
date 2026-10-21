import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';

enum MonAIFieldMark { ai, check }

class MonAIMarkedField extends StatelessWidget {
  const MonAIMarkedField({
    required this.label,
    required this.child,
    super.key,
    this.mark,
    this.error,
    this.checkCaption,
    this.aiLabel,
    this.leading,
    this.onTap,
    this.height = defaultHeight,
  });

  static const defaultHeight = 52.0;

  final String label;
  final Widget child;
  final MonAIFieldMark? mark;
  final String? error;
  final String? checkCaption;
  final String? aiLabel;
  final Widget? leading;
  final VoidCallback? onTap;

  final double height;

  /// For a text field inside a [MonAIMarkedField]; the app's input theme would
  /// draw a second box.
  static InputDecoration bareDecoration({String? hint, TextStyle? hintStyle}) =>
      InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        filled: false,
        hintText: hint,
        hintStyle: hintStyle,
        counterText: '',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final (fill, border, borderWidth) = switch ((error, mark)) {
      (_?, _) => (c.errorContainer, c.error, MonAISizes.borderFocused),
      (null, MonAIFieldMark.check) => (
        c.warningContainer,
        c.warning,
        MonAISizes.borderFocused,
      ),
      (null, MonAIFieldMark.ai) => (
        c.primaryContainer,
        c.primaryContainerBorder,
        MonAISizes.border,
      ),
      (null, null) => (c.surfaceSunken, c.border, MonAISizes.border),
    };
    final caption = switch ((error, mark, checkCaption)) {
      (final error?, _, _) => (error, c.errorText),
      (null, MonAIFieldMark.check, final text?) => (text, c.onWarningContainer),
      _ => null,
    };
    final box = SizedBox(
      height: height,
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x3_5),
        child: Row(
          spacing: MonAISpacing.x2,
          children: [
            ?leading,
            Expanded(child: child),
            ...switch (mark) {
              MonAIFieldMark.ai => [
                MonAIIcon(
                  MonAIIcons.autoAwesome,
                  size: MonAISizes.iconMd,
                  color: c.accent,
                  semanticLabel: aiLabel,
                ),
              ],
              MonAIFieldMark.check => [
                MonAIIcon(
                  MonAIIcons.warning,
                  size: MonAISizes.iconMd,
                  color: c.warning,
                ),
              ],
              null when onTap != null => [
                MonAIIcon(
                  MonAIIcons.expandMore,
                  size: MonAISizes.iconMd,
                  color: c.textTertiary,
                ),
              ],
              null => const <Widget>[],
            },
          ],
        ),
      ),
    );
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.fieldLabelGap,
      children: [
        Text(label, style: t.labelMedium?.copyWith(color: c.textSecondary)),
        Material(
          color: fill,
          shape: RoundedRectangleBorder(
            borderRadius: MonAIRadius.mdAll,
            side: BorderSide(color: border, width: borderWidth),
          ),
          clipBehavior: .antiAlias,
          child: switch (onTap) {
            final onTap? => InkWell(
              onTap: onTap,
              child: Semantics(button: true, child: box),
            ),
            null => box,
          },
        ),
        if (caption case (final text, final color))
          Text(text, style: t.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
