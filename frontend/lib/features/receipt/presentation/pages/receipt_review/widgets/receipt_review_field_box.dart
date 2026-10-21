import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_field.dart';

/// A labelled field of the review, tinted by how it was filled: indigo
/// with a sparkle when the AI read it surely, amber with a warning when the
/// user should check it, red with the message when it is invalid.
class ReceiptReviewFieldBox extends StatelessWidget {
  const ReceiptReviewFieldBox({
    required this.label,
    required this.child,
    super.key,
    this.mark,
    this.error,
    this.leading,
    this.onTap,
    this.height = _height,
  });

  static const _height = 52.0;

  final String label;

  /// The value: text, or a text field.
  final Widget child;

  /// How the AI filled it; null once the user changed it.
  final FieldMark? mark;

  /// The field's error message.
  final String? error;

  /// A widget before the value, e.g. the category's icon.
  final Widget? leading;

  /// Opens a picker. Null for a text field.
  final VoidCallback? onTap;

  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final (fill, border, borderWidth) = switch ((error, mark)) {
      (_?, _) => (c.errorContainer, c.error, MonAISizes.borderFocused),
      (null, FieldMark.check) => (
        c.warningContainer,
        c.warning,
        MonAISizes.borderFocused,
      ),
      (null, FieldMark.ai) => (
        c.primaryContainer,
        c.primaryContainerBorder,
        MonAISizes.border,
      ),
      (null, null) => (c.surfaceSunken, c.border, MonAISizes.border),
    };
    final caption = switch ((error, mark)) {
      (final error?, _) => (error, c.errorText),
      (null, FieldMark.check) => (
        l10n.receiptReviewCheckValue,
        c.onWarningContainer,
      ),
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
              FieldMark.ai => [
                MonAIIcon(
                  MonAIIcons.autoAwesome,
                  size: MonAISizes.iconMd,
                  color: c.accent,
                  semanticLabel: l10n.receiptReviewFilledByAi,
                ),
              ],
              FieldMark.check => [
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

/// A text field drawn without a frame of its own, for inside
/// [ReceiptReviewFieldBox]; the app's input theme would add a second box.
InputDecoration receiptBareDecoration({String? hint, TextStyle? hintStyle}) =>
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
