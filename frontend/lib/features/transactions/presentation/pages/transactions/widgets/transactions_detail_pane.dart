import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/transaction_detail_page.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';

/// Tablet landscape: the selected transaction beside the list, or a prompt
/// to pick one.
class TransactionsDetailPane extends StatelessWidget {
  const TransactionsDetailPane({super.key});

  void _clearSelection(BuildContext context) => context
      .read<TransactionsBloc>()
      .add(const TransactionsEvent.selected(null));

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionsBloc, TransactionsState, String?>(
      selector: (state) => state.selectedId,
      builder: (context, id) => switch (id) {
        final id? => TransactionDetailPage(
          id: id,
          placement: .pane,
          onClosed: () => _clearSelection(context),
        ),
        null => Center(
          child: Padding(
            padding: const .all(MonAISpacing.x8),
            child: MonAIStateMessage(
              icon: MonAIIcons.receiptLong,
              title: context.l10n.transactionsSelectPrompt,
              message: '',
            ),
          ),
        ),
      },
    );
  }
}
