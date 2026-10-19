import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/components/monai_button.dart';
import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_colors.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// The color family of an alert, banner or state.
enum MonAIAlertTone {
  info,
  success,
  warning,
  error;

  /// The icon used when none is given.
  MonAIIconData get defaultIcon => switch (this) {
    info => MonAIIcons.autoAwesome,
    success => MonAIIcons.checkCircle,
    warning => MonAIIcons.warning,
    error => MonAIIcons.error,
  };

  _ToneColors _colors(MonAIColors c) => switch (this) {
    info => _ToneColors(
      c.primaryContainer,
      null,
      c.accent,
      c.onPrimaryContainer,
    ),
    success => _ToneColors(c.incomeContainer, null, c.success, c.successText),
    warning => _ToneColors(
      c.warningContainer,
      c.warningContainerBorder,
      c.warning,
      c.onWarningContainer,
    ),
    error => _ToneColors(
      c.errorContainer,
      c.errorContainerBorder,
      c.error,
      c.onErrorContainer,
    ),
  };
}

class _ToneColors {
  const _ToneColors(this.container, this.border, this.icon, this.content);

  final Color container;
  final Color? border;
  final Color icon;
  final Color content;
}

/// Inline message box, e.g. the sign-in error or the "We'll set up a Cash
/// wallet" note.
class MonAIInlineAlert extends StatelessWidget {
  /// Creates an inline alert.
  const MonAIInlineAlert({
    required this.message,
    super.key,
    this.tone = MonAIAlertTone.info,
    this.icon,
  });

  /// The text.
  final String message;

  /// The color family.
  final MonAIAlertTone tone;

  /// Defaults to [MonAIAlertTone.defaultIcon].
  final MonAIIconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = tone._colors(context.colors);
    return Semantics(
      liveRegion: tone == .error,
      child: Container(
        width: double.infinity,
        padding: const .all(MonAISpacing.x3),
        decoration: BoxDecoration(
          color: t.container,
          borderRadius: MonAIRadius.mdAll,
          border: switch (t.border) {
            final color? => Border.all(color: color),
            null => null,
          },
        ),
        child: Row(
          crossAxisAlignment: .start,
          spacing: MonAISpacing.x2_5,
          children: [
            MonAIIcon(
              icon ?? tone.defaultIcon,
              size: MonAISizes.iconLg,
              color: t.icon,
            ),
            Expanded(
              child: Text(
                message,
                style: context.textStyles.bodyCompact.copyWith(
                  color: t.content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width 40 strip under a screen title: "**You're offline** · Showing
/// saved data".
class MonAIStatusStrip extends StatelessWidget {
  /// Creates a status strip.
  const MonAIStatusStrip({
    required this.title,
    super.key,
    this.detail,
    this.icon = MonAIIcons.cloudOff,
    this.tone = MonAIAlertTone.warning,
  });

  /// The bold part.
  final String title;

  /// The text after the dot.
  final String? detail;

  /// The leading icon.
  final MonAIIconData icon;

  /// The color family.
  final MonAIAlertTone tone;

  @override
  Widget build(BuildContext context) {
    final t = tone._colors(context.colors);
    final borderSide = BorderSide(color: t.border ?? t.container);
    return Semantics(
      liveRegion: true,
      child: Container(
        height: MonAISizes.statusStrip,
        padding: const .symmetric(horizontal: MonAISpacing.x4),
        decoration: BoxDecoration(
          color: t.container,
          border: Border(top: borderSide, bottom: borderSide),
        ),
        child: Row(
          spacing: MonAISpacing.x2,
          children: [
            MonAIIcon(icon, size: MonAISizes.iconMd, color: t.icon),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: const TextStyle().withWeight(.w600),
                    ),
                    if (detail case final detail?) TextSpan(text: ' · $detail'),
                  ],
                ),
                maxLines: 1,
                overflow: .ellipsis,
                style: context.textStyles.bodyCompact.copyWith(
                  color: t.content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the design's dark floating snackbar, with an optional leading
/// [icon] and action ("Undo").
///
/// [iconColor] defaults to the warning amber; pass e.g. the success green for
/// a confirmation.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMonAISnackBar(
  BuildContext context, {
  required String message,
  MonAIIconData? icon,
  Color? iconColor,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration,
}) {
  final c = context.colors;
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      content: _SnackBarContent(
        message: message,
        icon: icon,
        iconColor: iconColor ?? c.warning,
      ),
      action: switch (actionLabel) {
        final label? => SnackBarAction(
          label: label,
          textColor: c.inverseAccent,
          onPressed: onAction ?? () {},
        ),
        null => null,
      },
      duration:
          duration ??
          (actionLabel == null
              ? const Duration(seconds: 4)
              : const Duration(seconds: 10)),
      margin: const .fromLTRB(
        MonAISpacing.screenHorizontal,
        0,
        MonAISpacing.screenHorizontal,
        MonAISpacing.x5,
      ),
      padding: .only(
        left: MonAISpacing.x3_5,
        right: actionLabel == null ? MonAISpacing.x3_5 : MonAISpacing.x1_5,
        top: actionLabel == null ? MonAISpacing.x3 : MonAISpacing.x1_5,
        bottom: actionLabel == null ? MonAISpacing.x3 : MonAISpacing.x1_5,
      ),
    ),
  );
}

class _SnackBarContent extends StatelessWidget {
  const _SnackBarContent({
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  final String message;
  final MonAIIconData? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: MonAISpacing.x2_5,
      children: [
        if (icon case final icon?)
          MonAIIcon(icon, size: MonAISizes.iconLg, color: iconColor),
        Expanded(
          child: Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onInverseSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Centered 312 dialog: tone icon, title, body, optional extra content, then
/// dismiss + confirm buttons aligned to the end.
///
/// Show it with [showDialog]. A lone action (no [dismissLabel]) spans the
/// dialog, as in "Session expired".
class MonAIAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  const MonAIAlertDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    super.key,
    this.dismissLabel,
    this.onDismiss,
    this.icon,
    this.tone = MonAIAlertTone.warning,
    this.destructive = false,
    this.confirmLoading = false,
    this.content,
  });

  /// The heading.
  final String title;

  /// The body.
  final String message;

  /// The main action's label.
  final String confirmLabel;

  /// The main action.
  final VoidCallback onConfirm;

  /// The secondary button's label; none when null.
  final String? dismissLabel;

  /// Defaults to popping the dialog.
  final VoidCallback? onDismiss;

  /// An icon on a tone-colored circle above the title.
  final MonAIIconData? icon;

  /// The icon's color family.
  final MonAIAlertTone tone;

  /// Makes the confirm button red.
  final bool destructive;

  /// Shows a spinner on the confirm button.
  final bool confirmLoading;

  /// Extra content between the message and the buttons.
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final single = dismissLabel == null;
    final confirm = MonAIButton(
      label: confirmLabel,
      onPressed: onConfirm,
      variant: destructive ? .destructive : .primary,
      size: single ? .medium : .compact,
      loading: confirmLoading,
      expand: single,
    );
    return Dialog(
      insetPadding: const .all(MonAISpacing.x6),
      child: SizedBox(
        width: MonAISizes.dialogWidth,
        child: Padding(
          padding: const .all(MonAISpacing.x6),
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            namesRoute: true,
            label: title,
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              spacing: MonAISpacing.x3_5,
              children: [
                if (icon case final icon?) _DialogIcon(icon: icon, tone: tone),
                Text(title, style: t.headlineSmall),
                Text(
                  message,
                  style: t.bodyMedium?.copyWith(color: c.textSecondary),
                ),
                ?content,
                Padding(
                  padding: const .only(top: MonAISpacing.x1),
                  child: Row(
                    mainAxisAlignment: .end,
                    spacing: MonAISpacing.x2,
                    children: [
                      if (dismissLabel case final label?)
                        MonAIButton(
                          label: label,
                          onPressed: onDismiss ?? () => Navigator.pop(context),
                          variant: .text,
                          size: .compact,
                        ),
                      if (single) Expanded(child: confirm) else confirm,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogIcon extends StatelessWidget {
  const _DialogIcon({required this.icon, required this.tone});

  final MonAIIconData icon;
  final MonAIAlertTone tone;

  @override
  Widget build(BuildContext context) {
    final t = tone._colors(context.colors);
    return Container(
      width: MonAISizes.dialogIcon,
      height: MonAISizes.dialogIcon,
      alignment: .center,
      decoration: BoxDecoration(color: t.container, shape: .circle),
      child: MonAIIcon(icon, color: t.icon),
    );
  }
}

/// Shows a modal bottom sheet with the design's 24 top corners, 32×4 handle,
/// 24 side padding and optional [title].
Future<T?> showMonAIBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: (context) =>
        MonAIBottomSheet(title: title, child: builder(context)),
  );
}

/// The body of a bottom sheet: handle, optional title and [child].
///
/// [showMonAIBottomSheet] wraps its builder in this; use it directly only for
/// custom sheet routes.
class MonAIBottomSheet extends StatelessWidget {
  /// Creates a sheet body.
  const MonAIBottomSheet({required this.child, super.key, this.title});

  /// The sheet's content.
  final Widget child;

  /// The heading.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Center(
              child: Container(
                margin: const .only(
                  top: MonAISpacing.x3,
                  bottom: MonAISpacing.x0_5,
                ),
                width: MonAISizes.sheetHandleWidth,
                height: MonAISizes.sheetHandleHeight,
                decoration: BoxDecoration(
                  color: c.borderStrong,
                  borderRadius: MonAIRadius.fullAll,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const .fromLTRB(
                  MonAISpacing.screenHorizontalWide,
                  MonAISpacing.x3,
                  MonAISpacing.screenHorizontalWide,
                  MonAISpacing.x6,
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  spacing: MonAISpacing.x3_5,
                  children: [
                    if (title case final title?)
                      Text(title, style: context.textTheme.headlineSmall),
                    Flexible(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The two equal buttons at the foot of a picker sheet: an outlined one and
/// the main action.
class MonAISheetButtons extends StatelessWidget {
  /// Creates sheet buttons.
  const MonAISheetButtons({
    required this.secondaryLabel,
    required this.onSecondary,
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
    this.primaryLoading = false,
  });

  /// The outlined button's label, e.g. "Cancel".
  final String secondaryLabel;

  /// The outlined button's action.
  final VoidCallback? onSecondary;

  /// The main button's label, e.g. "Apply".
  final String primaryLabel;

  /// The main button's action.
  final VoidCallback? onPrimary;

  /// Shows a spinner on the main button.
  final bool primaryLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: MonAISpacing.x1),
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          Expanded(
            child: MonAIButton(
              label: secondaryLabel,
              onPressed: onSecondary,
              variant: .outlined,
              size: .medium,
              expand: true,
            ),
          ),
          Expanded(
            child: MonAIButton(
              label: primaryLabel,
              onPressed: onPrimary,
              size: .medium,
              loading: primaryLoading,
              expand: true,
            ),
          ),
        ],
      ),
    );
  }
}
