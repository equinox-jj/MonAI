import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

enum MonAIFieldTone { neutral, error, success }

/// No fill, border or counter, so the app's `inputDecorationTheme` doesn't
/// draw a second box inside the design's frame.
InputDecoration _bareDecoration(String? hint, TextStyle? hintStyle) {
  return InputDecoration(
    isCollapsed: true,
    // The theme's padding is for boxed fields; here it would push the text
    // off the frame's center.
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
}

class MonAITextField extends StatefulWidget {
  const MonAITextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.label,
    this.placeholder,
    this.leadingIcon,
    this.prefix,
    this.trailing,
    this.supportingText,
    this.supportingLinkLabel,
    this.onSupportingLinkTap,
    this.tone = MonAIFieldTone.neutral,
    this.compact = false,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? label;
  final String? placeholder;
  final MonAIIconData? leadingIcon;
  final String? prefix;
  final Widget? trailing;
  final String? supportingText;
  final String? supportingLinkLabel;
  final VoidCallback? onSupportingLinkTap;
  final MonAIFieldTone tone;
  final bool compact;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  State<MonAITextField> createState() => _MonAITextFieldState();
}

class _MonAITextFieldState extends State<MonAITextField> {
  FocusNode? _ownFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final isError = widget.tone == .error;
    final compact = widget.compact;
    final trailing =
        widget.trailing ??
        (isError
            ? MonAIIcon(
                MonAIIcons.error,
                size: MonAISizes.iconLg,
                color: c.error,
              )
            : null);

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: MonAISpacing.fieldLabelGap,
      children: [
        if (widget.label case final label?)
          Text(label, style: t.labelMedium?.copyWith(color: c.textSecondary)),
        _FieldFrame(
          focusNode: _focusNode,
          isError: isError,
          height: compact ? MonAISizes.inputCompact : MonAISizes.input,
          padding: .only(
            left: compact ? MonAISpacing.x3 : MonAISpacing.x3_5,
            right: widget.trailing != null
                ? MonAISpacing.x1
                : compact
                ? MonAISpacing.x3
                : MonAISpacing.x3_5,
          ),
          child: Row(
            spacing: compact ? MonAISpacing.x2 : MonAISpacing.x2_5,
            children: [
              if (widget.leadingIcon case final icon?)
                MonAIIcon(icon, size: MonAISizes.iconLg, color: c.textTertiary),
              if (widget.prefix case final prefix?)
                Text(
                  prefix,
                  style: t.titleMedium?.copyWith(color: c.textTertiary),
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  inputFormatters: widget.inputFormatters,
                  maxLength: widget.maxLength,
                  maxLengthEnforcement: widget.maxLength == null
                      ? null
                      : MaxLengthEnforcement.enforced,
                  style: t.bodyLarge?.copyWith(
                    color: widget.enabled ? c.textPrimary : c.textDisabled,
                  ),
                  cursorColor: c.focus,
                  decoration: _bareDecoration(
                    widget.placeholder,
                    t.bodyLarge?.copyWith(color: c.textDisabled),
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
        if (widget.supportingText case final text?)
          _SupportingText(
            text: text,
            tone: widget.tone,
            linkLabel: widget.supportingLinkLabel,
            onLinkTap: widget.onSupportingLinkTap,
          ),
      ],
    );
  }
}

/// Only this rebuilds when focus changes, to swap the border.
class _FieldFrame extends StatelessWidget {
  const _FieldFrame({
    required this.focusNode,
    required this.isError,
    required this.height,
    required this.padding,
    required this.child,
  });

  final FocusNode focusNode;
  final bool isError;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, child) {
        final (borderWidth, borderColor) = isError
            ? (MonAISizes.borderFocused, c.error)
            : focusNode.hasFocus
            ? (MonAISizes.borderFocused, c.focus)
            : (MonAISizes.border, c.border);
        return Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: c.surfaceSunken,
            borderRadius: MonAIRadius.mdAll,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _SupportingText extends StatefulWidget {
  const _SupportingText({
    required this.text,
    required this.tone,
    required this.linkLabel,
    required this.onLinkTap,
  });

  final String text;
  final MonAIFieldTone tone;
  final String? linkLabel;
  final VoidCallback? onLinkTap;

  @override
  State<_SupportingText> createState() => _SupportingTextState();
}

class _SupportingTextState extends State<_SupportingText> {
  final _recognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = switch (widget.tone) {
      .neutral => c.textTertiary,
      .error => c.errorText,
      .success => c.successText,
    };
    final style = context.textTheme.bodySmall?.copyWith(color: color);
    _recognizer.onTap = widget.onLinkTap;
    final text = switch (widget.linkLabel) {
      null => Text(widget.text, style: style),
      // One text node, so screen readers read message and link together.
      final link => Text.rich(
        TextSpan(
          text: '${widget.text} ',
          children: [
            TextSpan(
              text: link,
              recognizer: _recognizer,
              style: TextStyle(color: c.accent).withWeight(.w600),
            ),
          ],
        ),
        style: style,
      ),
    };
    return Semantics(
      liveRegion: widget.tone == .error,
      child: Row(
        spacing: MonAISpacing.x1_5,
        children: [
          if (widget.tone == .success)
            MonAIIcon(
              MonAIIcons.checkCircle,
              size: MonAISizes.iconSm,
              color: color,
            ),
          Flexible(child: text),
        ],
      ),
    );
  }
}

class MonAIPasswordField extends StatefulWidget {
  const MonAIPasswordField({
    required this.showPasswordLabel,
    required this.hidePasswordLabel,
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.label,
    this.placeholder,
    this.supportingText,
    this.tone = MonAIFieldTone.neutral,
    this.enabled = true,
    this.textInputAction,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? label;
  final String? placeholder;
  final String? supportingText;
  final MonAIFieldTone tone;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String showPasswordLabel;
  final String hidePasswordLabel;

  @override
  State<MonAIPasswordField> createState() => _MonAIPasswordFieldState();
}

class _MonAIPasswordFieldState extends State<MonAIPasswordField> {
  final _visible = ValueNotifier(false);

  @override
  void dispose() {
    _visible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _visible,
      builder: (context, visible, _) => MonAITextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        label: widget.label,
        placeholder: widget.placeholder,
        leadingIcon: MonAIIcons.lock,
        trailing: MonAIIconButton(
          icon: visible ? MonAIIcons.visibilityOff : MonAIIcons.visibility,
          tooltip: visible
              ? widget.hidePasswordLabel
              : widget.showPasswordLabel,
          onPressed: () => _visible.value = !visible,
          color: context.colors.textSecondary,
        ),
        supportingText: widget.supportingText,
        tone: widget.tone,
        enabled: widget.enabled,
        obscureText: !visible,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
      ),
    );
  }
}

class MonAISearchField extends StatefulWidget {
  const MonAISearchField({
    required this.placeholder,
    required this.clearLabel,
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  final String placeholder;
  final String clearLabel;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  State<MonAISearchField> createState() => _MonAISearchFieldState();
}

class _MonAISearchFieldState extends State<MonAISearchField> {
  TextEditingController? _ownController;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void dispose() {
    _ownController?.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return _PillFrame(
      height: MonAISizes.searchField,
      children: [
        MonAIIcon(
          MonAIIcons.search,
          size: MonAISizes.iconLg,
          color: c.textTertiary,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            autofocus: widget.autofocus,
            textInputAction: TextInputAction.search,
            style: t.bodyLarge?.copyWith(color: c.textPrimary),
            cursorColor: c.focus,
            decoration: _bareDecoration(
              widget.placeholder,
              t.bodyLarge?.copyWith(color: c.textTertiary),
            ),
          ),
        ),
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => _controller.text.isEmpty
              ? const SizedBox(width: MonAISpacing.x2_5)
              : MonAIIconButton(
                  icon: MonAIIcons.close,
                  tooltip: widget.clearLabel,
                  onPressed: _clear,
                  size: MonAISizes.buttonSmall,
                  iconSize: MonAISizes.iconLg,
                  color: c.textTertiary,
                ),
        ),
      ],
    );
  }
}

class MonAIPillField extends StatelessWidget {
  const MonAIPillField({
    required this.text,
    required this.leadingIcon,
    required this.onTap,
    super.key,
    this.leadingIconColor,
    this.height = MonAISizes.searchField,
  });

  final String text;
  final MonAIIconData leadingIcon;
  final VoidCallback onTap;
  final Color? leadingIconColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: _PillFrame(
        height: height,
        onTap: onTap,
        children: [
          MonAIIcon(
            leadingIcon,
            size: MonAISizes.iconLg,
            color: leadingIconColor ?? c.textTertiary,
          ),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: c.textTertiary,
              ),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillFrame extends StatelessWidget {
  const _PillFrame({required this.height, required this.children, this.onTap});

  final double height;
  final List<Widget> children;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: height,
      child: Material(
        color: c.surface,
        shape: StadiumBorder(side: BorderSide(color: c.borderStrong)),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .only(
              left: MonAISpacing.x4,
              right: MonAISpacing.x1_5,
            ),
            child: Row(spacing: MonAISpacing.x2_5, children: children),
          ),
        ),
      ),
    );
  }
}
