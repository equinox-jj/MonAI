import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/model/transactions_state_extension.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_actions.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_detail_pane.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_header.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_list.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_skeleton.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_states.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_category_filter_sheet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_filter_chips.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_month_picker_sheet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_type_filter_sheet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_wallet_filter_sheet.dart';
import 'package:monai/route_path.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TransactionsBloc>()..add(const TransactionsEvent.started()),
      child: const TransactionsUI(),
    );
  }
}

class TransactionsUI extends StatelessWidget {
  const TransactionsUI({super.key});
  static const _loadMoreExtent = 600.0;
  static const _listPaneWidth = 420.0;

  void _openSearch(BuildContext context) => context.push(
    RoutePath.transactionSearchIn(context.read<TransactionsBloc>().state.month),
  );

  void _addTransaction(BuildContext context) =>
      context.push(RoutePath.transactionNew);

  void _openTransaction(BuildContext context, String id) {
    if (context.widthClass == .expanded) {
      context.read<TransactionsBloc>().add(TransactionsEvent.selected(id));
    } else {
      context.push(RoutePath.transactionDetail(id));
    }
  }

  void _send(BuildContext context, TransactionsEvent event) =>
      context.read<TransactionsBloc>().add(event);

  void _openFilter(BuildContext context, TransactionFilterKind kind) {
    final bloc = context.read<TransactionsBloc>();
    final state = bloc.state;
    final l10n = context.l10n;
    switch (kind) {
      case .month:
        bloc.add(TransactionsEvent.monthPickerYearShown(state.month.year));
        showMonAIBottomSheet<void>(
          context,
          title: l10n.transactionsChooseMonth,
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: _MonthPicker(selected: state.month, bloc: bloc),
          ),
        );
      case .wallet:
        showMonAIBottomSheet<void>(
          context,
          title: l10n.filterWalletsTitle,
          builder: (_) => TransactionWalletFilterSheet(
            wallets: state.lookups.allWallets,
            selectedId: state.filter.walletId,
            onApply: (id) => bloc.add(TransactionsEvent.walletFilterPicked(id)),
          ),
        );
      case .category:
        showMonAIBottomSheet<void>(
          context,
          title: l10n.filterCategoriesTitle,
          builder: (_) => TransactionCategoryFilterSheet(
            categories: state.lookups.visibleCategories,
            selectedId: state.filter.categoryId,
            onApply: (id) =>
                bloc.add(TransactionsEvent.categoryFilterPicked(id)),
          ),
        );
      case .type:
        showMonAIBottomSheet<void>(
          context,
          title: l10n.filterTypeTitle,
          builder: (_) => TransactionTypeFilterSheet(
            selected: state.filter.type,
            onApply: (type) =>
                bloc.add(TransactionsEvent.typeFilterPicked(type)),
          ),
        );
    }
  }

  Future<void> _pullToRefresh(BuildContext context) async {
    final bloc = context.read<TransactionsBloc>()
      ..add(const TransactionsEvent.refreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    if (notification.metrics.axis == .vertical &&
        notification.metrics.extentAfter < _loadMoreExtent) {
      _send(context, const TransactionsEvent.loadMoreRequested());
    }
    return false;
  }

  void _showActionFailure(BuildContext context, TransactionsState state) {
    final failure = state.actionFailure;
    if (failure == null) return;
    final l10n = context.l10n;
    showMonAISnackBar(
      context,
      message: failure == .network
          ? l10n.transactionsRefreshFailedNetwork
          : failure.message(l10n),
      icon: failure == .network ? MonAIIcons.cloudOff : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = TransactionsActions(
      onSearch: () => _openSearch(context),
      onPreviousMonth: () =>
          _send(context, const TransactionsEvent.previousMonthPressed()),
      onNextMonth: () =>
          _send(context, const TransactionsEvent.nextMonthPressed()),
      onOpenFilter: (kind) => _openFilter(context, kind),
      onClearFilters: () =>
          _send(context, const TransactionsEvent.filtersCleared()),
      onOpenTransaction: (id) => _openTransaction(context, id),
      onDeleteTransaction: (id) =>
          _send(context, TransactionsEvent.deleteRequested(id)),
      onAddTransaction: () => _addTransaction(context),
      onRetry: () => _send(context, const TransactionsEvent.refreshed()),
    );
    final isExpanded = context.widthClass == .expanded;
    final list = RefreshIndicator(
      onRefresh: () => _pullToRefresh(context),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onScroll(context, notification),
        child: _TransactionsScrollView(
          actions: actions,
          showSelection: isExpanded,
        ),
      ),
    );

    return ColoredBox(
      color: context.colors.background,
      child: SafeArea(
        bottom: false,
        child: BlocListener<TransactionsBloc, TransactionsState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
          child: isExpanded
              ? Row(
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(width: _listPaneWidth, child: list),
                    VerticalDivider(
                      width: MonAISizes.border,
                      thickness: MonAISizes.border,
                      color: context.colors.border,
                    ),
                    const Expanded(child: TransactionsDetailPane()),
                  ],
                )
              : list,
        ),
      ),
    );
  }
}

class _TransactionsScrollView extends StatelessWidget {
  const _TransactionsScrollView({
    required this.actions,
    required this.showSelection,
  });

  final TransactionsActions actions;
  final bool showSelection;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: TransactionsHeader(actions: actions)),
        BlocSelector<TransactionsBloc, TransactionsState, UiStatus>(
          selector: (state) => state.status,
          builder: (context, status) => switch (status) {
            .initial ||
            .loading => const SliverToBoxAdapter(child: TransactionsSkeleton()),
            .failure => SliverFillRemaining(
              hasScrollBody: false,
              child: TransactionsLoadError(actions: actions),
            ),
            .empty => SliverFillRemaining(
              hasScrollBody: false,
              child: TransactionsEmpty(actions: actions),
            ),
            .success => TransactionsListSliver(
              actions: actions,
              showSelection: showSelection,
            ),
          },
        ),
      ],
    );
  }
}

class _MonthPicker extends StatelessWidget {
  const _MonthPicker({required this.selected, required this.bloc});

  final DateTime selected;
  final TransactionsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TransactionsBloc,
      TransactionsState,
      (Map<DateTime, int>, DateTime)
    >(
      selector: (state) => (state.monthPickerTotals, state.currentMonth),
      builder: (context, selected) => TransactionMonthPickerSheet(
        selected: this.selected,
        currentMonth: selected.$2,
        totals: selected.$1,
        onYearShown: (year) =>
            bloc.add(TransactionsEvent.monthPickerYearShown(year)),
        onApply: (month) => bloc.add(TransactionsEvent.monthPicked(month)),
      ),
    );
  }
}
