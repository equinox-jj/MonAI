import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';

/// How a field the AI or the phone filled is shown.
enum MonAIFieldMark {
  /// Read with confidence: a sparkle.
  ai,

  /// Missing, guessed or unsure: a warning asking the user to check it.
  check,
}

/// A labelled field of a drafted transaction, tinted by how it was filled:
/// indigo with a sparkle when read surely, amber with a warning when the
/// user should check it, red with the message when it is invalid.
class MonAIMarkedField extends StatelessWidget {
  /// Creates a marked field.
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

  /// The height of a one-line field.
  static const defaultHeight = 52.0;

  final String label;

  /// The value: text, or a text field drawn with [bareDecoration].
  final Widget child;

  /// How it was filled; null once the user changed it.
  final MonAIFieldMark? mark;

  /// The field's error message.
  final String? error;

  /// Shown under a [MonAIFieldMark.check] field, e.g. "Please check this
  /// value".
  final String? checkCaption;

  /// Read out for the sparkle of a [MonAIFieldMark.ai] field.
  final String? aiLabel;

  /// A widget before the value, e.g. the category's icon.
  final Widget? leading;

  /// Opens a picker. Null for a text field.
  final VoidCallback? onTap;

  final double height;

  /// A text field drawn without a frame of its own, for inside a
  /// [MonAIMarkedField]; the app's input theme would add a second box.
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
