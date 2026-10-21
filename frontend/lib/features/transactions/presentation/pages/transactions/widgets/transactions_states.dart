import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/model/transactions_state_extension.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_actions.dart';

class TransactionsLoadError extends StatelessWidget {
  const TransactionsLoadError({required this.actions, super.key});

  final TransactionsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Centered(
      child:
          BlocSelector<
            TransactionsBloc,
            TransactionsState,
            (TransactionFailure?, bool)
          >(
            selector: (state) => (state.loadFailure, state.isRefreshing),
            builder: (context, selected) {
              final (failure, isRetrying) = selected;
              return MonAIStateMessage(
                icon: failure == .network
                    ? MonAIIcons.cloudOff
                    : MonAIIcons.error,
                tone: .error,
                title: l10n.transactionsLoadErrorTitle,
                message: (failure ?? .unexpected).message(l10n),
                actionLabel: l10n.transactionsRetry,
                actionIcon: MonAIIcons.refresh,
                actionLoading: isRetrying,
                onAction: actions.onRetry,
              );
            },
          ),
    );
  }
}

class TransactionsEmpty extends StatelessWidget {
  const TransactionsEmpty({required this.actions, super.key});

  final TransactionsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Centered(
      child:
          BlocSelector<TransactionsBloc, TransactionsState, (bool, DateTime)>(
            selector: (state) => (state.hasFilter, state.month),
            builder: (context, selected) {
              final (hasFilter, month) = selected;
              if (hasFilter) {
                return MonAIStateMessage(
                  icon: MonAIIcons.filterAltOff,
                  title: l10n.transactionsFilteredEmptyTitle,
                  message: l10n.transactionsFilteredEmptyBody,
                  actionLabel: l10n.transactionsClearFilters,
                  onAction: actions.onClearFilters,
                );
              }
              return MonAIStateMessage(
                icon: MonAIIcons.receiptLong,
                title: l10n.transactionsEmptyTitle,
                message: l10n.transactionsEmptyBody(
                  TransactionDates.monthYear(month, context.localeName),
                ),
                actionLabel: l10n.transactionsAdd,
                actionIcon: MonAIIcons.add,
                onAction: actions.onAddTransaction,
              );
            },
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
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x10,
          vertical: MonAISpacing.x8,
        ),
        child: child,
      ),
    );
  }
}
