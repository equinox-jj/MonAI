import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

@immutable
class MonAINavItem {
  const MonAINavItem({
    required this.label,
    required this.icon,
    MonAIIconData? selectedIcon,
  }) : selectedIcon = selectedIcon ?? icon;

  static List<MonAINavItem> main({
    required String home,
    required String transactions,
    required String wallets,
    required String settings,
  }) => [
    MonAINavItem(
      label: home,
      icon: MonAIIcons.home,
      selectedIcon: MonAIIcons.homeFilled,
    ),
    MonAINavItem(
      label: transactions,
      icon: MonAIIcons.receiptLong,
      selectedIcon: MonAIIcons.receiptLongFilled,
    ),
    MonAINavItem(
      label: wallets,
      icon: MonAIIcons.accountBalanceWallet,
      selectedIcon: MonAIIcons.accountBalanceWalletFilled,
    ),
    MonAINavItem(
      label: settings,
      icon: MonAIIcons.settings,
      selectedIcon: MonAIIcons.settingsFilled,
    ),
  ];

  final String label;
  final MonAIIconData icon;
  final MonAIIconData selectedIcon;
}

class MonAIBottomBar extends StatelessWidget {
  const MonAIBottomBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onAdd,
    required this.addLabel,
    super.key,
  });

  final List<MonAINavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final half = (items.length + 1) ~/ 2;
    Widget item(int index) => Expanded(
      child: _BarItem(
        item: items[index],
        selected: index == selectedIndex,
        onTap: () => onSelect(index),
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
        boxShadow: c.isDark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x0D101828),
                  blurRadius: 12,
                  offset: Offset(0, -4),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MonAISizes.navBar - MonAISizes.border,
          child: Row(
            children: [
              ...List.generate(half, item),
              Expanded(
                child: _RaisedAddButton(onTap: onAdd, label: addLabel),
              ),
              ...List.generate(items.length - half, (j) => item(half + j)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final MonAINavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: MonAISizes.navIndicatorWidth / 2,
        child: Column(
          mainAxisAlignment: .center,
          spacing: MonAISpacing.x1,
          children: [
            _Indicator(
              item: item,
              selected: selected,
              width: MonAISizes.navIndicatorWidth,
            ),
            Text(
              item.label,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                color: selected ? c.textPrimary : c.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.item,
    required this.selected,
    required this.width,
  });

  final MonAINavItem item;
  final bool selected;
  final double width;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: MonAISizes.navIndicatorHeight,
      alignment: .center,
      decoration: BoxDecoration(
        color: selected ? c.primaryContainer : c.surface,
        borderRadius: MonAIRadius.fullAll,
      ),
      child: MonAIIcon(
        selected ? item.selectedIcon : item.icon,
        color: selected ? c.accent : c.textTertiary,
      ),
    );
  }
}

class _RaisedAddButton extends StatelessWidget {
  const _RaisedAddButton({required this.onTap, required this.label});

  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    // 56 button + 4 ring in the page background, raised so it breaks the
    // bar's top edge.
    return OverflowBox(
      maxHeight: double.infinity,
      child: Transform.translate(
        offset: const Offset(0, -15),
        child: Tooltip(
          message: label,
          child: Semantics(
            button: true,
            enabled: enabled,
            label: label,
            excludeSemantics: true,
            child: Container(
              width: MonAISizes.fab + 8,
              height: MonAISizes.fab + 8,
              decoration: BoxDecoration(
                shape: .circle,
                border: Border.all(color: c.background, width: 4),
                boxShadow: enabled && !c.isDark
                    ? [
                        BoxShadow(
                          color: c.primary.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: enabled ? c.primary : c.disabledContainer,
                shape: const CircleBorder(),
                clipBehavior: .antiAlias,
                child: InkWell(
                  onTap: onTap,
                  child: Center(
                    child: MonAIIcon(
                      MonAIIcons.add,
                      size: MonAISizes.iconXl,
                      color: enabled ? c.onPrimary : c.disabledContent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MonAINavigationRail extends StatelessWidget {
  const MonAINavigationRail({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onAdd,
    required this.addLabel,
    super.key,
  });

  final List<MonAINavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: MonAISizes.navRail,
      decoration: BoxDecoration(
        color: c.surface,
        border: BorderDirectional(end: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        right: false,
        // Scrolls when the window is short, e.g. with the keyboard up.
        child: SingleChildScrollView(
          padding: const .symmetric(vertical: MonAISpacing.x6),
          child: Column(
            spacing: MonAISpacing.x4,
            children: [
              Padding(
                padding: const .only(bottom: MonAISpacing.x6),
                child: Tooltip(
                  message: addLabel,
                  child: Semantics(
                    label: addLabel,
                    excludeSemantics: true,
                    button: true,
                    child: _AddSquareButton(
                      onTap: onAdd,
                      width: MonAISizes.fab,
                      child: const MonAIIcon(
                        MonAIIcons.add,
                        size: MonAISizes.iconXl,
                      ),
                    ),
                  ),
                ),
              ),
              ...List.generate(
                items.length,
                (i) => _RailItem(
                  item: items[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final MonAINavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: MonAISizes.navRailIndicatorWidth / 2,
        child: SizedBox(
          width: MonAISizes.navRail,
          child: Column(
            spacing: MonAISpacing.x1,
            children: [
              _Indicator(
                item: item,
                selected: selected,
                width: MonAISizes.navRailIndicatorWidth,
              ),
              Text(
                item.label,
                maxLines: 1,
                overflow: .ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: selected ? c.textPrimary : c.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonAINavigationDrawer extends StatelessWidget {
  const MonAINavigationDrawer({
    required this.title,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onAdd,
    required this.addLabel,
    super.key,
  });

  final String title;
  final List<MonAINavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: MonAISizes.navDrawer,
      decoration: BoxDecoration(
        color: c.surface,
        border: BorderDirectional(end: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        right: false,
        // Scrolls when the window is short, e.g. with the keyboard up.
        child: SingleChildScrollView(
          padding: const .symmetric(
            vertical: MonAISpacing.x6,
            horizontal: MonAISpacing.x4,
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x1,
            children: [
              _DrawerHeader(title: title),
              Padding(
                padding: const .only(bottom: MonAISpacing.x4),
                child: Semantics(
                  button: true,
                  child: _AddSquareButton(
                    onTap: onAdd,
                    child: Padding(
                      padding: const .symmetric(horizontal: MonAISpacing.x5),
                      child: Row(
                        spacing: MonAISpacing.x2_5,
                        children: [
                          const MonAIIcon(MonAIIcons.add),
                          Flexible(
                            child: Text(
                              addLabel,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: context.textTheme.titleSmall?.withWeight(
                                .w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ...List.generate(
                items.length,
                (i) => _DrawerItem(
                  item: items[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const .fromLTRB(
        MonAISpacing.x2,
        0,
        MonAISpacing.x2,
        MonAISpacing.x5,
      ),
      child: Row(
        spacing: MonAISpacing.x2_5,
        children: [
          Container(
            width: MonAISizes.navDrawerLogo,
            height: MonAISizes.navDrawerLogo,
            alignment: .center,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: MonAIRadius.mdAll,
            ),
            child: MonAIIcon(
              MonAIIcons.accountBalanceWallet,
              size: MonAISizes.iconLg,
              color: c.onPrimary,
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.textTheme.titleMedium
                  ?.withWeight(.w700)
                  .copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final MonAINavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final content = selected ? c.onPrimaryContainer : c.textSecondary;
    return Semantics(
      selected: selected,
      button: true,
      child: SizedBox(
        height: MonAISizes.navDrawerItem,
        child: Material(
          color: selected ? c.primaryContainer : c.surface,
          shape: const StadiumBorder(),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const .symmetric(horizontal: MonAISpacing.x4),
              child: Row(
                spacing: MonAISpacing.x3,
                children: [
                  MonAIIcon(
                    selected ? item.selectedIcon : item.icon,
                    color: content,
                  ),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: content,
                      ),
                    ),
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

class _AddSquareButton extends StatelessWidget {
  const _AddSquareButton({
    required this.onTap,
    required this.child,
    this.width,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    final foreground = enabled ? c.onPrimary : c.disabledContent;
    return Container(
      width: width,
      height: MonAISizes.fab,
      decoration: BoxDecoration(
        borderRadius: MonAIRadius.lgAll,
        boxShadow: enabled && !c.isDark
            ? [
                BoxShadow(
                  color: c.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: enabled ? c.primary : c.disabledContainer,
        borderRadius: MonAIRadius.lgAll,
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: IconTheme.merge(
            data: IconThemeData(color: foreground),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: foreground),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
