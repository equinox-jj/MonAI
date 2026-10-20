import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/router/app_router.dart';

/// The signed-in app: the main tabs around the current one. Phones get a
/// bottom bar, tablet portrait a rail and tablet landscape a drawer.
///
/// Each tab is a branch of [navigationShell], which keeps its own stack and
/// state while another tab is shown.
class DashboardPage extends StatelessWidget {
  const DashboardPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Shows the tab at [index]; tapping the current tab returns it to its root.
  void _selectTab(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  void _addTransaction(BuildContext context) =>
      context.push(AppRoutes.transactionNew);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = MonAINavItem.main(
      home: l10n.navHome,
      transactions: l10n.navTransactions,
      wallets: l10n.navWallets,
      settings: l10n.navSettings,
    );
    final selectedIndex = navigationShell.currentIndex;

    return switch (context.widthClass) {
      .compact => Scaffold(
        body: navigationShell,
        bottomNavigationBar: MonAIBottomBar(
          items: items,
          selectedIndex: selectedIndex,
          onSelect: _selectTab,
          onAdd: () => _addTransaction(context),
          addLabel: l10n.navAddTransaction,
        ),
      ),
      .medium => _SideNavLayout(
        navigation: MonAINavigationRail(
          items: items,
          selectedIndex: selectedIndex,
          onSelect: _selectTab,
          onAdd: () => _addTransaction(context),
          addLabel: l10n.navAddTransaction,
        ),
        child: navigationShell,
      ),
      .expanded => _SideNavLayout(
        navigation: MonAINavigationDrawer(
          title: l10n.appTitle,
          items: items,
          selectedIndex: selectedIndex,
          onSelect: _selectTab,
          onAdd: () => _addTransaction(context),
          addLabel: l10n.navAddTransaction,
        ),
        child: navigationShell,
      ),
    };
  }
}

/// The tablet layout: the rail or drawer at the start, the tab beside it.
class _SideNavLayout extends StatelessWidget {
  const _SideNavLayout({required this.navigation, required this.child});

  final Widget navigation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: .stretch,
        children: [
          navigation,
          Expanded(child: child),
        ],
      ),
    );
  }
}
