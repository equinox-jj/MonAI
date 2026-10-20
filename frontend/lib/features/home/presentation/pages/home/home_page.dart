import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_actions.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_balance_card.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_budget_card.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_header.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_load_error.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_quick_add.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_recent.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_skeleton.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_spending_card.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_wallets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeEvent.started()),
      child: const HomeUI(),
    );
  }
}

/// The dashboard, its skeleton while the first load runs, or the error when
/// that load failed.
class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  void _openWallets(BuildContext context) => context.go(AppRoutes.wallets);

  void _openTransactions(BuildContext context) =>
      context.go(AppRoutes.transactions);

  void _openSettings(BuildContext context) => context.go(AppRoutes.settings);

  void _openSearch(BuildContext context) =>
      context.push(AppRoutes.transactionSearchIn());

  // TODO(home): open quick add once it exists.
  void _openQuickAdd() {}

  void _openScanReceipt(BuildContext context) =>
      context.push(AppRoutes.receiptScan);

  void _openWallet(BuildContext context, String walletId) =>
      context.push(AppRoutes.walletDetail(walletId));

  void _addWallet(BuildContext context) => context.push(AppRoutes.walletNew);

  void _openBudget(BuildContext context) => context.push(AppRoutes.budgetFor());

  void _openReport(BuildContext context) => context.push(AppRoutes.reportFor());

  void _openTransaction(BuildContext context, String transactionId) =>
      context.push(AppRoutes.transactionDetail(transactionId));

  void _addTransaction(BuildContext context) =>
      context.push(AppRoutes.transactionNew);

  void _refresh(BuildContext context) =>
      context.read<HomeBloc>().add(const HomeEvent.refreshed());

  /// Pull-to-refresh keeps its spinner until the refresh finishes.
  Future<void> _pullToRefresh(BuildContext context) async {
    final bloc = context.read<HomeBloc>()..add(const HomeEvent.refreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  void _showRefreshFailure(BuildContext context, HomeState state) {
    final l10n = context.l10n;
    switch (state.refreshFailure) {
      case .network:
        showMonAISnackBar(
          context,
          message: l10n.homeRefreshFailedNetwork,
          icon: MonAIIcons.cloudOff,
        );
      case .unexpected:
        showMonAISnackBar(context, message: l10n.homeRefreshFailedUnexpected);
      case null:
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = HomeActions(
      onSearch: () => _openSearch(context),
      onProfile: () => _openSettings(context),
      onQuickAdd: _openQuickAdd,
      onScanReceipt: () => _openScanReceipt(context),
      onSeeAllWallets: () => _openWallets(context),
      onOpenWallet: (id) => _openWallet(context, id),
      onAddWallet: () => _addWallet(context),
      onOpenBudget: () => _openBudget(context),
      onOpenReport: () => _openReport(context),
      onSeeAllTransactions: () => _openTransactions(context),
      onOpenTransaction: (id) => _openTransaction(context, id),
      onAddTransaction: () => _addTransaction(context),
      onToggleBalance: () => context.read<HomeBloc>().add(
        const HomeEvent.balanceVisibilityToggled(),
      ),
      onRetry: () => _refresh(context),
    );

    return ColoredBox(
      color: context.colors.background,
      child: SafeArea(
        bottom: false,
        child: BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              current.refreshFailure != null &&
              previous.refreshFailure != current.refreshFailure,
          listener: _showRefreshFailure,
          child: BlocSelector<HomeBloc, HomeState, UiStatus>(
            selector: (state) => state.status,
            builder: (context, status) => switch (status) {
              .initial || .loading => const HomeSkeleton(),
              .failure => HomeLoadError(onRetry: actions.onRetry),
              .success || .empty => RefreshIndicator(
                onRefresh: () => _pullToRefresh(context),
                child: _Dashboard(actions: actions),
              ),
            },
          ),
        ),
      ),
    );
  }
}

typedef _Sections = ({
  bool showQuickAdd,
  bool showWallets,
  bool showBudget,
  bool showSpending,
});

/// Picks the layout for the window width and the sections worth showing.
class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.actions});

  final HomeActions actions;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, _Sections>(
      selector: (state) => (
        showQuickAdd: !state.isFirstRun,
        showWallets: state.showWallets,
        showBudget: state.budgetDisplay != .hidden,
        showSpending: state.dashboard?.spending.isNotEmpty ?? false,
      ),
      builder: (context, sections) => switch (context.widthClass) {
        .compact => _CompactDashboard(actions: actions, sections: sections),
        .medium => _MediumDashboard(actions: actions, sections: sections),
        .expanded => _ExpandedDashboard(actions: actions, sections: sections),
      },
    );
  }
}

/// Phones: one column. A month with nothing recorded leaves out quick add.
class _CompactDashboard extends StatelessWidget {
  const _CompactDashboard({required this.actions, required this.sections});

  final HomeActions actions;
  final _Sections sections;

  @override
  Widget build(BuildContext context) {
    const width = MonAIWidthClass.compact;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .symmetric(vertical: MonAISpacing.screenTop),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.sectionGap,
        children: [
          _Padded(
            child: HomeHeader(actions: actions, widthClass: width),
          ),
          _Padded(
            child: HomeBalanceCard(actions: actions, widthClass: width),
          ),
          if (sections.showQuickAdd)
            _Padded(
              child: HomeQuickAdd(
                onQuickAdd: actions.onQuickAdd,
                onScanReceipt: actions.onScanReceipt,
              ),
            ),
          if (sections.showWallets)
            HomeWallets(actions: actions, widthClass: width),
          if (sections.showBudget)
            _Padded(
              child: HomeBudgetCard(
                onOpenBudget: actions.onOpenBudget,
                widthClass: width,
              ),
            ),
          if (sections.showSpending)
            _Padded(
              child: HomeSpendingCard(
                onOpenReport: actions.onOpenReport,
                widthClass: width,
              ),
            ),
          _Padded(
            child: HomeRecent(actions: actions, widthClass: width),
          ),
        ],
      ),
    );
  }
}

/// Tablet portrait: full-width header, balance and wallet grid, then the
/// budget and spending cards side by side, then Recent.
class _MediumDashboard extends StatelessWidget {
  const _MediumDashboard({required this.actions, required this.sections});

  final HomeActions actions;
  final _Sections sections;

  @override
  Widget build(BuildContext context) {
    const width = MonAIWidthClass.medium;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .all(MonAISpacing.x6),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x4,
        children: [
          HomeHeader(actions: actions, widthClass: width),
          HomeBalanceCard(actions: actions, widthClass: width),
          if (sections.showWallets)
            HomeWallets(actions: actions, widthClass: width),
          if (sections.showBudget || sections.showSpending)
            Row(
              crossAxisAlignment: .start,
              spacing: MonAISpacing.x4,
              children: [
                if (sections.showBudget)
                  Expanded(
                    child: HomeBudgetCard(
                      onOpenBudget: actions.onOpenBudget,
                      widthClass: width,
                    ),
                  ),
                if (sections.showSpending)
                  Expanded(
                    child: HomeSpendingCard(
                      onOpenReport: actions.onOpenReport,
                      widthClass: width,
                    ),
                  ),
              ],
            ),
          HomeRecent(actions: actions, widthClass: width),
        ],
      ),
    );
  }
}

/// Tablet landscape: the balance beside the budget, then spending beside
/// Recent. The drawer already lists the wallets' tab, so there are no
/// wallet cards.
class _ExpandedDashboard extends StatelessWidget {
  const _ExpandedDashboard({required this.actions, required this.sections});

  final HomeActions actions;
  final _Sections sections;

  @override
  Widget build(BuildContext context) {
    const width = MonAIWidthClass.expanded;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .symmetric(
        horizontal: MonAISpacing.x8,
        vertical: MonAISpacing.x6,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x6,
        children: [
          HomeHeader(actions: actions, widthClass: width),
          Row(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x6,
            children: [
              Expanded(
                flex: 8,
                child: HomeBalanceCard(actions: actions, widthClass: width),
              ),
              if (sections.showBudget)
                Expanded(
                  flex: 4,
                  child: HomeBudgetCard(
                    onOpenBudget: actions.onOpenBudget,
                    widthClass: width,
                  ),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x6,
            children: [
              if (sections.showSpending)
                Expanded(
                  flex: 7,
                  child: HomeSpendingCard(
                    onOpenReport: actions.onOpenReport,
                    widthClass: width,
                  ),
                ),
              Expanded(
                flex: 5,
                child: HomeRecent(actions: actions, widthClass: width),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Padded extends StatelessWidget {
  const _Padded({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: MonAISpacing.screenHorizontal),
      child: child,
    );
  }
}
