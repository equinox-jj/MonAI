import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:monai/core/designsystem/components/monai_button.dart';
import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// The state a field's border and supporting text show.
enum MonAIFieldTone {
  /// Gray border, gray supporting text.
  neutral,

  /// Red 2px border, trailing error icon, red supporting text.
  error,

  /// Green supporting text with a check icon, e.g. "At least 8 characters".
  success,
}

/// An input decoration with no fill, border or counter, so the app's
/// `inputDecorationTheme` doesn't draw a second box inside the design's frame.
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

/// Filled text field: label above, gray fill, 12 corners, 2px indigo ring on
/// focus.
///
/// Pass a null [label] for label-less fields like the note input (then give
/// [placeholder]). [compact] makes it 48 tall instead of 56.
class MonAITextField extends StatefulWidget {
  /// Creates a text field.
  const MonAITextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.label,
    this.placeholder,
    this.leadingIcon,
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

  /// Holds the text. Created internally when null.
  final TextEditingController? controller;

  /// Focus of the input. Created internally when null.
  final FocusNode? focusNode;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  /// Called when the keyboard action is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Shown above the field.
  final String? label;

  /// Shown inside the field while it's empty.
  final String? placeholder;

  /// An icon at the start of the field.
  final MonAIIconData? leadingIcon;

  /// A widget at the end of the field, e.g. a visibility toggle.
  final Widget? trailing;

  /// Helper or error text under the field.
  final String? supportingText;

  /// An inline link after [supportingText], e.g. "Sign in instead".
  final String? supportingLinkLabel;

  /// Called when [supportingLinkLabel] is tapped.
  final VoidCallback? onSupportingLinkTap;

  /// Border and supporting-text state.
  final MonAIFieldTone tone;

  /// 48 tall instead of 56, for secondary inputs like the note.
  final bool compact;

  /// Whether the field accepts input.
  final bool enabled;

  /// Hides the text, for passwords.
  final bool obscureText;

  /// The keyboard to show.
  final TextInputType? keyboardType;

  /// The keyboard's action button.
  final TextInputAction? textInputAction;

  /// What autofill should offer, e.g. [AutofillHints.email].
  final Iterable<String>? autofillHints;

  /// Restricts or reformats input.
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum characters, without a visible counter.
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

/// The filled, rounded box around the input. Only this rebuilds when focus
/// changes, to swap the border.
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

/// [MonAITextField] with a lock icon and a show/hide toggle.
class MonAIPasswordField extends StatefulWidget {
  /// Creates a password field. The toggle labels are read by screen readers;
  /// pass localized strings.
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

  /// Holds the text. Created internally when null.
  final TextEditingController? controller;

  /// Focus of the input.
  final FocusNode? focusNode;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  /// Called when the keyboard action is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Shown above the field.
  final String? label;

  /// Shown inside the field while it's empty.
  final String? placeholder;

  /// Helper or error text under the field.
  final String? supportingText;

  /// Border and supporting-text state.
  final MonAIFieldTone tone;

  /// Whether the field accepts input.
  final bool enabled;

  /// The keyboard's action button.
  final TextInputAction? textInputAction;

  /// Autofill hints; [AutofillHints.newPassword] on sign-up.
  final Iterable<String>? autofillHints;

  /// Toggle label while the password is hidden.
  final String showPasswordLabel;

  /// Toggle label while the password is visible.
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

/// Pill search input on a surface (Transactions, search results).
///
/// Shows a clear button while it has text.
class MonAISearchField extends StatefulWidget {
  /// Creates a search field.
  const MonAISearchField({
    required this.placeholder,
    required this.clearLabel,
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  /// Shown while empty.
  final String placeholder;

  /// The clear button's accessibility label.
  final String clearLabel;

  /// Holds the text. Created internally when null.
  final TextEditingController? controller;

  /// Called on every edit, including clear.
  final ValueChanged<String>? onChanged;

  /// Called when search is pressed on the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Focuses the field when it first appears.
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

/// A pill that looks like an input but opens another screen: the Home search
/// and quick-add entries. [text] is placeholder-colored.
class MonAIPillField extends StatelessWidget {
  /// Creates a pill field.
  const MonAIPillField({
    required this.text,
    required this.leadingIcon,
    required this.onTap,
    super.key,
    this.leadingIconColor,
    this.height = MonAISizes.searchField,
  });

  /// The placeholder-like text.
  final String text;

  /// The icon at the start.
  final MonAIIconData leadingIcon;

  /// Opens the real input.
  final VoidCallback onTap;

  /// Defaults to the tertiary text color; quick-add uses the accent.
  final Color? leadingIconColor;

  /// 48 for search, [MonAISizes.quickAddField] for quick-add.
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

/// Read-only field that opens a picker: wallet, date, transfer From/To.
///
/// A [label] (small caption above [value]) makes the field 56 tall.
class MonAISelectField extends StatelessWidget {
  /// Creates a select field. A null [onTap] disables it.
  const MonAISelectField({
    required this.value,
    required this.onTap,
    super.key,
    this.leadingIcon,
    this.label,
    this.showChevron = false,
  });

  /// The selected value.
  final String value;

  /// Opens the picker. Null disables the field.
  final VoidCallback? onTap;

  /// An accent icon at the start.
  final MonAIIconData? leadingIcon;

  /// Caption above [value], e.g. "From".
  final String? label;

  /// Shows an expand chevron at the end.
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: SizedBox(
        height: label != null ? MonAISizes.input : MonAISizes.inputCompact,
        child: Material(
          color: c.surfaceSunken,
          shape: RoundedRectangleBorder(
            borderRadius: MonAIRadius.mdAll,
            side: BorderSide(color: c.border),
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const .symmetric(horizontal: MonAISpacing.x3),
              child: Row(
                spacing: MonAISpacing.x2,
                children: [
                  if (leadingIcon case final icon?)
                    MonAIIcon(icon, size: MonAISizes.iconLg, color: c.accent),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,
                      children: [
                        if (label case final label?)
                          Text(
                            label,
                            style: t.labelSmall
                                ?.withWeight(.w400)
                                .copyWith(color: c.textTertiary),
                          ),
                        Text(
                          value,
                          style: t.labelLarge?.copyWith(
                            color: enabled ? c.textPrimary : c.textDisabled,
                          ),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (showChevron)
                    MonAIIcon(
                      MonAIIcons.expandMore,
                      size: MonAISizes.iconMd,
                      color: c.textTertiary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
