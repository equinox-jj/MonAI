import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/components/monai_badges.dart';
import 'package:monai/core/designsystem/components/monai_surfaces.dart';
import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_colors.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// Two-line row: leading, title + supporting line, trailing.
///
/// 12/16 padding and an optional bottom divider, for rows stacked inside a
/// [MonAICard] with zero padding.
class MonAIListItem extends StatelessWidget {
  /// Creates a list row.
  const MonAIListItem({
    required this.title,
    super.key,
    this.supporting,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
  });

  /// The first line.
  final String title;

  /// The second, smaller line.
  final String? supporting;

  /// A widget at the start, e.g. a category icon.
  final Widget? leading;

  /// A widget at the end, e.g. an amount.
  final Widget? trailing;

  /// Makes the row tappable.
  final VoidCallback? onTap;

  /// Draws a divider under the row.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return Column(
      mainAxisSize: .min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .symmetric(
              horizontal: MonAISpacing.x4,
              vertical: MonAISpacing.x3,
            ),
            child: Row(
              spacing: MonAISpacing.x3,
              children: [
                ?leading,
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: t.titleMedium?.copyWith(color: c.textPrimary),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                      if (supporting case final supporting?)
                        Text(
                          supporting,
                          style: t.bodySmall?.copyWith(color: c.textTertiary),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
        if (showDivider) const MonAIDivider(),
      ],
    );
  }
}

/// Which way money moves, which colors an amount and picks its arrow.
enum MoneyDirection {
  /// Money out: red with a north-east arrow.
  expense,

  /// Money in: green with a south-west arrow.
  income,

  /// Between the user's wallets: neutral with a two-way arrow.
  transfer;

  /// The amount and arrow color.
  Color color(MonAIColors c) => switch (this) {
    expense => c.expense,
    income => c.income,
    transfer => c.transfer,
  };

  /// The arrow under the amount.
  MonAIIconData get arrow => switch (this) {
    expense => MonAIIcons.northEast,
    income => MonAIIcons.southWest,
    transfer => MonAIIcons.syncAlt,
  };
}

/// A transaction in a list: category icon, title, meta line, and the signed
/// amount with its direction arrow.
///
/// [amount] is already formatted with its sign (`−Rp 35.000`).
class MonAITransactionRow extends StatelessWidget {
  /// Creates a transaction row.
  const MonAITransactionRow({
    required this.title,
    required this.meta,
    required this.amount,
    required this.direction,
    required this.categoryIcon,
    required this.categoryColor,
    super.key,
    this.onTap,
    this.showDivider = false,
  });

  /// The note, merchant or category.
  final String title;

  /// `Food · GoPay · 12:40`.
  final String meta;

  /// The signed, formatted amount.
  final String amount;

  /// Colors the amount and picks the arrow.
  final MoneyDirection direction;

  /// The category's icon, or the transfer icon.
  final MonAIIconData categoryIcon;

  /// The category's light color.
  final Color categoryColor;

  /// Opens the transaction.
  final VoidCallback? onTap;

  /// Draws a divider under the row.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = direction.color(context.colors);
    return MonAIListItem(
      title: title,
      supporting: meta,
      onTap: onTap,
      showDivider: showDivider,
      leading: MonAICategoryIcon(icon: categoryIcon, color: categoryColor),
      trailing: Column(
        crossAxisAlignment: .end,
        children: [
          Text(
            amount,
            maxLines: 1,
            style: context.textStyles.amount.copyWith(color: color),
          ),
          MonAIIcon(direction.arrow, size: MonAISizes.iconSm, color: color),
        ],
      ),
    );
  }
}

/// Uppercase group header, a card of rows, and an optional footnote
/// (Settings).
class MonAISettingsGroup extends StatelessWidget {
  /// Creates a settings group. [children] are usually [MonAISettingsRow]s.
  const MonAISettingsGroup({
    required this.title,
    required this.children,
    super.key,
    this.footer,
  });

  /// The header; shown uppercase.
  final String title;

  /// The rows.
  final List<Widget> children;

  /// A note under the card.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: MonAISpacing.x1_5,
      children: [
        Padding(
          padding: const .only(left: MonAISpacing.x1),
          child: Text(
            title.toUpperCase(),
            style: context.textStyles.overline.copyWith(color: c.textTertiary),
          ),
        ),
        MonAICard(
          padding: .zero,
          child: Column(mainAxisSize: .min, children: children),
        ),
        if (footer case final footer?)
          Padding(
            padding: const .only(left: MonAISpacing.x1),
            child: Text(
              footer,
              style: context.textTheme.bodySmall?.copyWith(
                color: c.textTertiary,
              ),
            ),
          ),
      ],
    );
  }
}

/// 56 settings row: icon, label, value, chevron.
///
/// [destructive] makes the label and icon red, e.g. "Delete account".
class MonAISettingsRow extends StatelessWidget {
  /// Creates a settings row.
  const MonAISettingsRow({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
    this.value,
    this.showChevron = true,
    this.destructive = false,
    this.iconColor,
    this.showDivider = true,
  });

  /// The setting's name.
  final String label;

  /// The leading icon.
  final MonAIIconData icon;

  /// Opens the setting.
  final VoidCallback onTap;

  /// The current value, e.g. "Bahasa Indonesia".
  final String? value;

  /// Shows a chevron at the end.
  final bool showChevron;

  /// Red label and icon.
  final bool destructive;

  /// Overrides the icon color (accent, or red when [destructive]).
  final Color? iconColor;

  /// Draws a divider under the row; turn off for the last row.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      mainAxisSize: .min,
      children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: MonAISizes.settingsRow,
              child: Padding(
                padding: const .symmetric(horizontal: MonAISpacing.x4),
                child: Row(
                  spacing: MonAISpacing.x3,
                  children: [
                    MonAIIcon(
                      icon,
                      color:
                          iconColor ?? (destructive ? c.errorText : c.accent),
                    ),
                    Expanded(
                      child: Text(
                        label,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: destructive ? c.errorText : c.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                    if (value case final value?)
                      Text(
                        value,
                        style: context.textStyles.bodyCompact.copyWith(
                          color: c.textTertiary,
                        ),
                        maxLines: 1,
                      ),
                    if (showChevron)
                      MonAIIcon(MonAIIcons.chevronRight, color: c.textDisabled),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showDivider) const MonAIDivider(),
      ],
    );
  }
}

/// Selectable card used in picker sheets (wallet, theme, language): leading,
/// title with optional tag, subtitle, radio indicator.
class MonAIRadioOption extends StatelessWidget {
  /// Creates a radio option.
  const MonAIRadioOption({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.tag,
    this.leading,
  });

  /// The option's name.
  final String title;

  /// Whether this option is chosen.
  final bool selected;

  /// Chooses this option.
  final VoidCallback onTap;

  /// A second line.
  final String? subtitle;

  /// A [MonAITag] after the title, e.g. "DEFAULT".
  final String? tag;

  /// A widget at the start, e.g. a monogram.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: MonAISizes.pickerOption),
        child: Material(
          color: selected ? c.primaryContainer : c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: MonAIRadius.mdlAll,
            side: BorderSide(
              color: selected ? c.focus : c.border,
              width: selected ? MonAISizes.borderFocused : MonAISizes.border,
            ),
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const .symmetric(
                horizontal: MonAISpacing.x3_5,
                vertical: MonAISpacing.x2,
              ),
              child: Row(
                spacing: MonAISpacing.x3,
                children: [
                  ?leading,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          spacing: MonAISpacing.x1_5,
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: t.titleSmall
                                    ?.withWeight(.w600)
                                    .copyWith(color: c.textPrimary),
                              ),
                            ),
                            if (tag case final tag?) MonAITag(text: tag),
                          ],
                        ),
                        if (subtitle case final subtitle?)
                          Text(
                            subtitle,
                            style: t.bodySmall?.copyWith(color: c.textTertiary),
                          ),
                      ],
                    ),
                  ),
                  MonAIIcon(
                    selected
                        ? MonAIIcons.radioButtonChecked
                        : MonAIIcons.radioButtonUnchecked,
                    color: selected ? c.accent : c.textDisabled,
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
