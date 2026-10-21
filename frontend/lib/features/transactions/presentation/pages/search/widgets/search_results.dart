import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/search/model/search_state_extension.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_list_row.dart';

typedef _Results = ({
  List<Transaction> results,
  TransactionLookups lookups,
  bool hasMore,
  bool allMonths,
  DateTime month,
});

class SearchResults extends StatelessWidget {
  const SearchResults({
    required this.onOpen,
    required this.onToggleAllMonths,
    super.key,
  });

  final ValueChanged<String> onOpen;
  final ValueChanged<bool> onToggleAllMonths;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<SearchBloc, SearchState, _Results>(
      selector: (state) => (
        results: state.results,
        lookups: state.lookups,
        hasMore: state.hasMore,
        allMonths: state.allMonths,
        month: state.month,
      ),
      builder: (context, data) => ListView.builder(
        padding: const .only(bottom: MonAISpacing.x6),
        itemCount: data.results.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return const _Header();
          if (index == data.results.length + 1) {
            return data.hasMore
                ? const Padding(
                    padding: .all(MonAISpacing.x4),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Padding(
                    padding: const .all(MonAISpacing.x4),
                    child: Center(
                      child: MonAITextLink(
                        label: data.allMonths
                            ? l10n.searchMonthOnly(
                                TransactionDates.monthYear(
                                  data.month,
                                  context.localeName,
                                ),
                              )
                            : l10n.searchAllMonths,
                        onPressed: () => onToggleAllMonths(!data.allMonths),
                      ),
                    ),
                  );
          }
          final transaction = data.results[index - 1];
          return TransactionListRow(
            transaction: transaction,
            lookups: data.lookups,
            showDate: true,
            showDivider: index < data.results.length,
            onTap: onOpen,
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.labelLarge?.copyWith(
      color: context.colors.textSecondary,
    );
    return BlocSelector<SearchBloc, SearchState, (int, int)>(
      selector: (state) => (state.results.length, state.net),
      builder: (context, selected) {
        final (count, net) = selected;
        return Padding(
          padding: const .fromLTRB(
            MonAISpacing.screenHorizontal,
            MonAISpacing.x3,
            MonAISpacing.screenHorizontal,
            MonAISpacing.x2,
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(context.l10n.searchResultCount(count), style: style),
              Text(formatRupiah(net), style: style),
            ],
          ),
        );
      },
    );
  }
}
