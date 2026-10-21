import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_list_item.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/model/transactions_state_extension.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_actions.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_day_header.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_list_row.dart';

typedef _ListData = ({
  List<TransactionListItem> items,
  TransactionLookups lookups,
  DateTime today,
  String? selectedId,
  bool hasMore,
});

class TransactionsListSliver extends StatelessWidget {
  const TransactionsListSliver({
    required this.actions,
    super.key,
    this.showSelection = false,
  });

  final TransactionsActions actions;
  final bool showSelection;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionsBloc, TransactionsState, _ListData>(
      selector: (state) => (
        items: state.items,
        lookups: state.lookups,
        today: state.today,
        selectedId: showSelection ? state.selectedId : null,
        hasMore: state.hasMore,
      ),
      builder: (context, data) => SliverPadding(
        padding: const .only(bottom: MonAISpacing.x6),
        sliver: SliverList.builder(
          itemCount: data.items.length + (data.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == data.items.length) return const _LoadingMore();
            return switch (data.items[index]) {
              TransactionDayItem(:final date, :final net) =>
                TransactionDayHeader(day: date, today: data.today, net: net),
              TransactionEntryItem(:final transaction, :final isLastOfDay) =>
                _SwipeToDelete(
                  id: transaction.id,
                  onDelete: actions.onDeleteTransaction,
                  child: TransactionListRow(
                    transaction: transaction,
                    lookups: data.lookups,
                    showDivider: !isLastOfDay,
                    selected: transaction.id == data.selectedId,
                    onTap: actions.onOpenTransaction,
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _SwipeToDelete extends StatelessWidget {
  const _SwipeToDelete({
    required this.id,
    required this.onDelete,
    required this.child,
  });

  final String id;
  final ValueChanged<String> onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Dismissible(
      key: ValueKey(id),
      direction: .endToStart,
      onDismissed: (_) => onDelete(id),
      background: ColoredBox(
        color: c.error,
        child: Align(
          alignment: .centerRight,
          child: SizedBox(
            width: 96,
            child: Column(
              mainAxisAlignment: .center,
              spacing: MonAISpacing.x0_5,
              children: [
                const MonAIIcon(
                  MonAIIcons.delete,
                  size: MonAISizes.iconMd,
                  color: Colors.white,
                ),
                Text(
                  context.l10n.transactionsDelete,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}

class _LoadingMore extends StatelessWidget {
  const _LoadingMore();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .all(MonAISpacing.x4),
      child: Center(
        child: SizedBox.square(
          dimension: MonAISizes.icon,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
