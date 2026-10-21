import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/components/monai_badges.dart';
import 'package:monai/core/ui/designsystem/components/monai_surfaces.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

class MonAIListItem extends StatelessWidget {
  const MonAIListItem({
    required this.title,
    super.key,
    this.supporting,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
  });

  final String title;
  final String? supporting;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
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

enum MoneyDirection {
  expense,
  income,
  transfer;

  Color color(MonAIColors c) => switch (this) {
    expense => c.expense,
    income => c.income,
    transfer => c.transfer,
  };

  MonAIIconData get arrow => switch (this) {
    expense => MonAIIcons.northEast,
    income => MonAIIcons.southWest,
    transfer => MonAIIcons.syncAlt,
  };
}

class MonAITransactionRow extends StatelessWidget {
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

  final String title;
  final String meta;
  final String amount;
  final MoneyDirection direction;
  final MonAIIconData categoryIcon;
  final Color categoryColor;
  final VoidCallback? onTap;
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

class MonAISettingsGroup extends StatelessWidget {
  const MonAISettingsGroup({
    required this.title,
    required this.children,
    super.key,
    this.footer,
  });

  final String title;
  final List<Widget> children;
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

class MonAISettingsRow extends StatelessWidget {
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

  final String label;
  final MonAIIconData icon;
  final VoidCallback onTap;
  final String? value;
  final bool showChevron;
  final bool destructive;
  final Color? iconColor;
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

class MonAIRadioOption extends StatelessWidget {
  const MonAIRadioOption({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.tag,
    this.leading,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final String? subtitle;
  final String? tag;
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
