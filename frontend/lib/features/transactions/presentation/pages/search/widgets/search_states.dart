import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';

typedef _Empty = ({
  String query,
  bool allMonths,
  bool hasFilter,
  DateTime month,
});

class SearchEmpty extends StatelessWidget {
  const SearchEmpty({
    required this.onClearFilters,
    required this.onSearchAllMonths,
    super.key,
  });

  final VoidCallback onClearFilters;
  final VoidCallback onSearchAllMonths;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Centered(
      child: BlocSelector<SearchBloc, SearchState, _Empty>(
        selector: (state) => (
          query: state.query.trim(),
          allMonths: state.allMonths,
          hasFilter: state.hasFilter,
          month: state.month,
        ),
        builder: (context, data) {
          final message = data.allMonths
              ? l10n.searchEmptyBodyAllMonths(data.query)
              : l10n.searchEmptyBody(
                  TransactionDates.monthYear(data.month, context.localeName),
                  data.query,
                );
          return MonAIStateMessage(
            icon: MonAIIcons.searchOff,
            title: l10n.searchEmptyTitle(data.query),
            message: message,
            actionLabel: data.hasFilter ? l10n.transactionsClearFilters : null,
            actionIcon: MonAIIcons.filterAltOff,
            onAction: onClearFilters,
            secondaryActionLabel: data.allMonths ? null : l10n.searchAllMonths,
            onSecondaryAction: onSearchAllMonths,
          );
        },
      ),
    );
  }
}

class SearchError extends StatelessWidget {
  const SearchError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Centered(
      child: BlocSelector<SearchBloc, SearchState, TransactionFailure?>(
        selector: (state) => state.failure,
        builder: (context, failure) => MonAIStateMessage(
          icon: failure == .network ? MonAIIcons.cloudOff : MonAIIcons.error,
          tone: .error,
          title: l10n.searchErrorTitle,
          message: (failure ?? .unexpected).message(l10n),
          actionLabel: l10n.transactionsRetry,
          actionIcon: MonAIIcons.refresh,
          onAction: onRetry,
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const .symmetric(
          horizontal: MonAISpacing.x10,
          vertical: MonAISpacing.x8,
        ),
        child: child,
      ),
    );
  }
}
