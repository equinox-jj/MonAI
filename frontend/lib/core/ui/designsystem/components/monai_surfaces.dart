import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';

class MonAICard extends StatelessWidget {
  const MonAICard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const .all(MonAISpacing.cardPadding),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: MonAIRadius.lgAll,
        side: BorderSide(color: c.border),
      ),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: c.textPrimary),
            child: child,
          ),
        ),
      ),
    );
  }
}

class MonAIGradientCard extends StatelessWidget {
  const MonAIGradientCard({
    required this.child,
    super.key,
    this.gradient,
    this.borderRadius = MonAIRadius.xxlAll,
    this.padding = const .all(MonAISpacing.x5),
    this.elevated = true,
    this.decorated = true,
    this.onTap,
  });

  final Widget child;
  final Gradient? gradient;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool elevated;
  final bool decorated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: elevated && !c.isDark
            ? [
                BoxShadow(
                  color: c.primary.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: Material(
        borderRadius: borderRadius,
        clipBehavior: .antiAlias,
        child: Ink(
          decoration: BoxDecoration(gradient: gradient ?? c.heroGradient),
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                if (decorated) const _DecorCircle(),
                Padding(
                  padding: padding,
                  child: IconTheme.merge(
                    data: const IconThemeData(color: Colors.white),
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.white),
                      child: child,
                    ),
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

class _DecorCircle extends StatelessWidget {
  const _DecorCircle();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -48,
      top: -56,
      child: IgnorePointer(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: .circle,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }
}

enum MonAITopBarNavigation { back, close, none }

enum ScreenPlacement {
  fullScreen,

  /// Beside a list on a wide screen: no navigation button, and the host owns
  /// the status bar.
  pane,

  /// A side sheet on a wide screen; the screen behind it owns the status bar.
  sideSheet,
}

class MonAITopBar extends StatelessWidget implements PreferredSizeWidget {
  const MonAITopBar({
    required this.title,
    super.key,
    this.navigation = MonAITopBarNavigation.back,
    this.onNavigationPressed,
    this.navigationTooltip,
    this.titleStyle,
    this.placement = ScreenPlacement.fullScreen,
    this.actions = const [],
  });

  final String title;
  final MonAITopBarNavigation navigation;
  final VoidCallback? onNavigationPressed;
  final String? navigationTooltip;
  final TextStyle? titleStyle;
  final ScreenPlacement placement;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(MonAISizes.topBar);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = MaterialLocalizations.of(context);
    final onPressed = onNavigationPressed ?? () => Navigator.maybePop(context);
    final shown = placement == .pane ? MonAITopBarNavigation.none : navigation;
    final leading = switch (shown) {
      .back => MonAIIconButton(
        icon: MonAIIcons.arrowBack,
        tooltip: navigationTooltip ?? l10n.backButtonTooltip,
        onPressed: onPressed,
      ),
      .close => MonAIIconButton(
        icon: MonAIIcons.close,
        tooltip: navigationTooltip ?? l10n.closeButtonTooltip,
        onPressed: onPressed,
        color: c.textSecondary,
      ),
      .none => const SizedBox(width: MonAISpacing.x2_5),
    };
    return SafeArea(
      top: placement == .fullScreen,
      bottom: false,
      child: SizedBox(
        height: MonAISizes.topBar,
        // 44 buttons sit 6 in, so their icons line up with the 16 content
        // edge.
        child: Padding(
          padding: const .symmetric(horizontal: MonAISpacing.x1_5),
          child: Row(
            spacing: MonAISpacing.x1,
            children: [
              leading,
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: (titleStyle ?? context.textTheme.titleLarge)
                        ?.copyWith(color: c.textPrimary),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class MonAIScreenTitle extends StatelessWidget {
  const MonAIScreenTitle({required this.title, super.key, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ),
        ?action,
      ],
    );
  }
}

class MonAISectionHeader extends StatelessWidget {
  const MonAISectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onActionPressed,
    this.style,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: (style ?? context.textTheme.headlineSmall)?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ),
        if (actionLabel case final label?)
          MonAITextLink(label: label, onPressed: onActionPressed),
      ],
    );
  }
}

class MonAITextLink extends StatelessWidget {
  const MonAITextLink({
    required this.label,
    required this.onPressed,
    super.key,
    this.trailingIcon,
    this.style,
  });

  final String label;
  final VoidCallback? onPressed;
  final MonAIIconData? trailingIcon;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.accent;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: MonAIRadius.smAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: MonAISizes.touchTarget),
          child: Padding(
            padding: const .symmetric(horizontal: MonAISpacing.x1),
            child: Row(
              mainAxisSize: .min,
              spacing: MonAISpacing.x1,
              children: [
                // Wraps instead of overflowing when given less than its width.
                Flexible(
                  child: Text(
                    label,
                    style: (style ?? context.textTheme.labelLarge)?.copyWith(
                      color: accent,
                    ),
                  ),
                ),
                if (trailingIcon case final icon?)
                  MonAIIcon(icon, size: MonAISizes.iconMd, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MonAIDivider extends StatelessWidget {
  const MonAIDivider({super.key, this.indent = 0});
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: MonAISizes.border,
      thickness: MonAISizes.border,
      indent: indent,
      color: context.colors.divider,
    );
  }
}
