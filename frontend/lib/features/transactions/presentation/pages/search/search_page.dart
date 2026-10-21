import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/app_router.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/search/model/search_state_extension.dart';
import 'package:monai/features/transactions/presentation/pages/search/widgets/search_recent.dart';
import 'package:monai/features/transactions/presentation/pages/search/widgets/search_results.dart';
import 'package:monai/features/transactions/presentation/pages/search/widgets/search_states.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_category_filter_sheet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_filter_chips.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_month_picker_sheet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_type_filter_sheet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_wallet_filter_sheet.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, this.initialMonth});
  final DateTime? initialMonth;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SearchBloc>(param1: initialMonth)
            ..add(const SearchEvent.started()),
      child: const SearchUI(),
    );
  }
}

class SearchUI extends StatefulWidget {
  const SearchUI({super.key});

  @override
  State<SearchUI> createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  final _query = TextEditingController();
  static const _loadMoreExtent = 600.0;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  SearchBloc get _bloc => context.read<SearchBloc>();

  void _send(SearchEvent event) => _bloc.add(event);

  void _useRecent(String query) {
    _query.text = query;
    _send(SearchEvent.recentUsed(query));
  }

  void _open(String id) => context.push(AppRoutes.transactionDetail(id));

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis == .vertical &&
        notification.metrics.extentAfter < _loadMoreExtent) {
      _send(const SearchEvent.loadMoreRequested());
    }
    return false;
  }

  void _openFilter(TransactionFilterKind kind) {
    final bloc = _bloc;
    final state = bloc.state;
    final l10n = context.l10n;
    switch (kind) {
      case .month:
        bloc.add(SearchEvent.monthPickerYearShown(state.month.year));
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
            onApply: (id) => bloc.add(SearchEvent.walletFilterPicked(id)),
          ),
        );
      case .category:
        showMonAIBottomSheet<void>(
          context,
          title: l10n.filterCategoriesTitle,
          builder: (_) => TransactionCategoryFilterSheet(
            categories: state.lookups.visibleCategories,
            selectedId: state.filter.categoryId,
            onApply: (id) => bloc.add(SearchEvent.categoryFilterPicked(id)),
          ),
        );
      case .type:
        showMonAIBottomSheet<void>(
          context,
          title: l10n.filterTypeTitle,
          builder: (_) => TransactionTypeFilterSheet(
            selected: state.filter.type,
            onApply: (type) => bloc.add(SearchEvent.typeFilterPicked(type)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(
                MonAISpacing.x1_5,
                MonAISpacing.x2,
                MonAISpacing.screenHorizontal,
                MonAISpacing.x2,
              ),
              child: Row(
                spacing: MonAISpacing.x1,
                children: [
                  MonAIIconButton(
                    icon: MonAIIcons.arrowBack,
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: MonAISearchField(
                      controller: _query,
                      placeholder: l10n.transactionsSearchHint,
                      clearLabel: l10n.searchClear,
                      autofocus: true,
                      onChanged: (query) =>
                          _send(SearchEvent.queryChanged(query)),
                      onSubmitted: (_) => _send(const SearchEvent.submitted()),
                    ),
                  ),
                ],
              ),
            ),
            BlocSelector<
              SearchBloc,
              SearchState,
              (TransactionFilter, TransactionLookups, String)
            >(
              selector: (state) => (
                state.filter,
                state.lookups,
                state.allMonths
                    ? l10n.searchAllMonthsChip
                    : TransactionDates.shortMonthYear(
                        state.month,
                        context.localeName,
                      ),
              ),
              builder: (context, selected) => TransactionFilterChips(
                filter: selected.$1,
                lookups: selected.$2,
                monthLabel: selected.$3,
                onOpen: _openFilter,
                onClearAll: () => _send(const SearchEvent.filtersCleared()),
              ),
            ),
            const SizedBox(height: MonAISpacing.x2),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: BlocSelector<SearchBloc, SearchState, UiStatus>(
                  selector: (state) => state.status,
                  builder: (context, status) => switch (status) {
                    .initial => SearchRecent(onUse: _useRecent),
                    .loading => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    .failure => SearchError(
                      onRetry: () => _send(const SearchEvent.retried()),
                    ),
                    .empty => SearchEmpty(
                      onClearFilters: () =>
                          _send(const SearchEvent.filtersCleared()),
                      onSearchAllMonths: () => _send(
                        const SearchEvent.allMonthsToggled(allMonths: true),
                      ),
                    ),
                    .success => SearchResults(
                      onOpen: _open,
                      onToggleAllMonths: (allMonths) => _send(
                        SearchEvent.allMonthsToggled(allMonths: allMonths),
                      ),
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthPicker extends StatelessWidget {
  const _MonthPicker({required this.selected, required this.bloc});

  final DateTime selected;
  final SearchBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SearchBloc,
      SearchState,
      (Map<DateTime, int>, DateTime)
    >(
      selector: (state) => (state.monthPickerTotals, state.currentMonth),
      builder: (context, data) => TransactionMonthPickerSheet(
        selected: selected,
        currentMonth: data.$2,
        totals: data.$1,
        onYearShown: (year) => bloc.add(SearchEvent.monthPickerYearShown(year)),
        onApply: (month) => bloc.add(SearchEvent.monthPicked(month)),
      ),
    );
  }
}
