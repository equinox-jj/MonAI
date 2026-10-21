import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/model/transactions_state_extension.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_actions.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_filter_chips.dart';

class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({required this.actions, super.key});

  final TransactionsActions actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(
        top: MonAISpacing.screenTop,
        bottom: MonAISpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x3,
        children: [
          _Padded(
            child: Text(
              context.l10n.transactionsTitle,
              style: context.textTheme.headlineSmall,
            ),
          ),
          _Padded(
            child: MonAIPillField(
              text: context.l10n.transactionsSearchHint,
              leadingIcon: MonAIIcons.search,
              onTap: actions.onSearch,
            ),
          ),
          _Padded(child: _MonthSwitcher(actions: actions)),
          _Filters(actions: actions),
          const _Padded(child: _MonthTotals()),
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

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({required this.actions});

  final TransactionsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<TransactionsBloc, TransactionsState, (DateTime, bool)>(
      selector: (state) => (state.month, state.canShowNextMonth),
      builder: (context, selected) {
        final (month, canShowNext) = selected;
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            MonAIIconButton(
              icon: MonAIIcons.chevronLeft,
              tooltip: l10n.transactionsPreviousMonth,
              onPressed: actions.onPreviousMonth,
            ),
            Semantics(
              button: true,
              hint: l10n.transactionsChooseMonth,
              child: InkWell(
                onTap: () => actions.onOpenFilter(.month),
                borderRadius: MonAIRadius.smAll,
                child: Padding(
                  padding: const .symmetric(
                    horizontal: MonAISpacing.x2,
                    vertical: MonAISpacing.x2_5,
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    spacing: MonAISpacing.x1,
                    children: [
                      Text(
                        TransactionDates.monthYear(month, context.localeName),
                        style: context.textTheme.titleMedium,
                      ),
                      MonAIIcon(
                        MonAIIcons.expandMore,
                        size: MonAISizes.iconMd,
                        color: context.colors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MonAIIconButton(
              icon: MonAIIcons.chevronRight,
              tooltip: l10n.transactionsNextMonth,
              onPressed: canShowNext ? actions.onNextMonth : null,
            ),
          ],
        );
      },
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.actions});

  final TransactionsActions actions;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TransactionsBloc,
      TransactionsState,
      (TransactionFilter, TransactionLookups)
    >(
      selector: (state) => (state.filter, state.lookups),
      builder: (context, selected) => TransactionFilterChips(
        filter: selected.$1,
        lookups: selected.$2,
        onOpen: actions.onOpenFilter,
        onClearAll: actions.onClearFilters,
      ),
    );
  }
}

class _MonthTotals extends StatelessWidget {
  const _MonthTotals();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<TransactionsBloc, TransactionsState, MonthlyReport?>(
      selector: (state) => state.report,
      builder: (context, report) => Row(
        spacing: MonAISpacing.x2,
        children: [
          Expanded(
            child: _TotalTile(
              label: l10n.transactionTypeIncome,
              amount: switch (report) {
                final report? => formatRupiahSigned(
                  report.incomeTotal,
                  negative: false,
                ),
                null => '–',
              },
              color: c.income,
            ),
          ),
          Expanded(
            child: _TotalTile(
              label: l10n.transactionTypeExpense,
              amount: switch (report) {
                final report? => formatRupiahSigned(
                  report.expenseTotal,
                  negative: true,
                ),
                null => '–',
              },
              color: c.expense,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: MonAIRadius.mdAll,
        border: Border.all(color: c.border),
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x3,
          vertical: MonAISpacing.x2_5,
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(label, style: t.bodySmall?.copyWith(color: c.textTertiary)),
            Text(
              amount,
              maxLines: 1,
              overflow: .ellipsis,
              style: t.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
