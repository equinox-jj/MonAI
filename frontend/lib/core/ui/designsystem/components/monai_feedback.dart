import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';

enum MonAIAlertTone {
  info,
  success,
  warning,
  error;

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

class MonAIInlineAlert extends StatelessWidget {
  const MonAIInlineAlert({
    required this.message,
    super.key,
    this.tone = MonAIAlertTone.info,
    this.icon,
  });

  final String message;
  final MonAIAlertTone tone;
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

class MonAIAlertDialog extends StatelessWidget {
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

  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final String? dismissLabel;
  final VoidCallback? onDismiss;
  final MonAIIconData? icon;
  final MonAIAlertTone tone;
  final bool destructive;
  final bool confirmLoading;
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
                  child: switch (dismissLabel) {
                    null => Row(children: [Expanded(child: confirm)]),
                    // Long labels stack, confirm on top, rather than
                    // overflow.
                    final label => OverflowBar(
                      alignment: .end,
                      spacing: MonAISpacing.x2,
                      overflowAlignment: .end,
                      overflowDirection: .up,
                      overflowSpacing: MonAISpacing.x1,
                      children: [
                        MonAIButton(
                          label: label,
                          onPressed: onDismiss ?? () => Navigator.pop(context),
                          variant: .text,
                          size: .compact,
                        ),
                        confirm,
                      ],
                    ),
                  },
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

Future<T?> showMonAIBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  Widget? titleTrailing,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: (context) => MonAIBottomSheet(
      title: title,
      titleTrailing: titleTrailing,
      child: builder(context),
    ),
  );
}

/// [showMonAIBottomSheet] wraps its builder in this; use it directly only for
/// custom sheet routes.
class MonAIBottomSheet extends StatelessWidget {
  const MonAIBottomSheet({
    required this.child,
    super.key,
    this.title,
    this.titleTrailing,
  });
  final Widget child;
  final String? title;
  final Widget? titleTrailing;

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
                      Row(
                        spacing: MonAISpacing.x3,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: context.textTheme.headlineSmall,
                            ),
                          ),
                          ?titleTrailing,
                        ],
                      ),
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

class MonAISheetButtons extends StatelessWidget {
  const MonAISheetButtons({
    required this.secondaryLabel,
    required this.onSecondary,
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
    this.primaryLoading = false,
  });

  final String secondaryLabel;
  final VoidCallback? onSecondary;
  final String primaryLabel;
  final VoidCallback? onPrimary;
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
