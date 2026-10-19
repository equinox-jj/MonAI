import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/components/monai_button.dart';
import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';

/// Surface card with a 1px border and 16 corners. Tappable when [onTap] is
/// set.
class MonAICard extends StatelessWidget {
  /// Creates a card.
  const MonAICard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const .all(MonAISpacing.cardPadding),
  });

  /// The card's content.
  final Widget child;

  /// Makes the whole card tappable.
  final VoidCallback? onTap;

  /// Inner padding; pass [EdgeInsets.zero] for stacked list rows.
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

/// Indigo gradient card with the decorative circle: the balance hero,
/// onboarding panel and wallet cards. Content is white.
class MonAIGradientCard extends StatelessWidget {
  /// Creates a gradient card. [gradient] defaults to the hero gradient.
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

  /// The card's content.
  final Widget child;

  /// The background; defaults to `context.colors.heroGradient`.
  final Gradient? gradient;

  /// Corner radius; wallet cards use [MonAIRadius.lgAll].
  final BorderRadius borderRadius;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Adds the indigo glow (light theme only).
  final bool elevated;

  /// Draws the translucent circle in the top-right corner.
  final bool decorated;

  /// Makes the whole card tappable.
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

/// The navigation button of a [MonAITopBar].
enum MonAITopBarNavigation {
  /// A back arrow.
  back,

  /// A close cross, for full-screen forms.
  close,

  /// No button.
  none,
}

/// Where a screen is shown, which decides its top bar's status-bar inset and
/// navigation button.
enum ScreenPlacement {
  /// Its own screen: the top bar sits below the status bar.
  fullScreen,

  /// Beside a list or menu on a wide screen: no navigation button, and the
  /// host owns the status bar.
  pane,

  /// A side sheet over the screen behind it on a wide screen, which owns the
  /// status bar.
  sideSheet,
}

/// Screen header for pushed screens and full-screen forms: back/close, title,
/// actions.
///
/// Only a [ScreenPlacement.fullScreen] bar pads for the status bar, and a
/// [ScreenPlacement.pane] has no navigation button. Usable as
/// [Scaffold.appBar].
class MonAITopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a top bar. [navigationTooltip] labels the back/close button.
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

  /// The title.
  final String title;

  /// The leading button.
  final MonAITopBarNavigation navigation;

  /// Called by the leading button; defaults to [Navigator.maybePop].
  final VoidCallback? onNavigationPressed;

  /// Defaults to the Material "Back" / "Close" label.
  final String? navigationTooltip;

  /// Defaults to `titleLarge`.
  final TextStyle? titleStyle;

  /// Where the screen is shown.
  final ScreenPlacement placement;

  /// Trailing buttons.
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

/// Tab-screen title ("Transactions", "Settings") with an optional trailing
/// action.
class MonAIScreenTitle extends StatelessWidget {
  /// Creates a screen title.
  const MonAIScreenTitle({required this.title, super.key, this.action});

  /// The title.
  final String title;

  /// A trailing widget, e.g. an icon button.
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

/// Section title with an optional "See all"-style link.
class MonAISectionHeader extends StatelessWidget {
  /// Creates a section header.
  const MonAISectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onActionPressed,
    this.style,
  });

  /// The title.
  final String title;

  /// The link text.
  final String? actionLabel;

  /// Called by the link.
  final VoidCallback? onActionPressed;

  /// Defaults to `headlineSmall`; card headers use `titleMedium`.
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

/// Inline accent link with a 44 touch height.
class MonAITextLink extends StatelessWidget {
  /// Creates a text link.
  const MonAITextLink({
    required this.label,
    required this.onPressed,
    super.key,
    this.trailingIcon,
    this.style,
  });

  /// The link text.
  final String label;

  /// Called on tap.
  final VoidCallback? onPressed;

  /// An icon after the text.
  final MonAIIconData? trailingIcon;

  /// Defaults to `labelLarge`.
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
                Text(
                  label,
                  style: (style ?? context.textTheme.labelLarge)?.copyWith(
                    color: accent,
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

/// A 1px divider in the theme's divider color.
class MonAIDivider extends StatelessWidget {
  /// Creates a divider. [indent] insets its start.
  const MonAIDivider({super.key, this.indent = 0});

  /// Start inset.
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
