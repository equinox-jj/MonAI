import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/widgets/transaction_detail_fields.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/widgets/transaction_detail_hero.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/widgets/transaction_detail_receipt.dart';
import 'package:monai/route_path.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({
    required this.id,
    super.key,
    this.placement = ScreenPlacement.fullScreen,
    this.onClosed,
  });

  final String id;
  final ScreenPlacement placement;
  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(id),
      create: (_) =>
          sl<TransactionDetailBloc>(param1: id)
            ..add(const TransactionDetailEvent.started()),
      child: TransactionDetailUI(placement: placement, onClosed: onClosed),
    );
  }
}

class TransactionDetailUI extends StatelessWidget {
  const TransactionDetailUI({
    super.key,
    this.placement = ScreenPlacement.fullScreen,
    this.onClosed,
  });

  final ScreenPlacement placement;
  final VoidCallback? onClosed;

  void _edit(BuildContext context) => context.push(
    RoutePath.transactionEdit(context.read<TransactionDetailBloc>().id),
  );

  void _delete(BuildContext context) => context
      .read<TransactionDetailBloc>()
      .add(const TransactionDetailEvent.deleteRequested());

  void _retry(BuildContext context) => context
      .read<TransactionDetailBloc>()
      .add(const TransactionDetailEvent.retried());

  void _close(BuildContext context, TransactionDetailState state) {
    if (onClosed case final onClosed?) {
      onClosed();
    } else {
      context.pop();
    }
  }

  void _showActionFailure(BuildContext context, TransactionDetailState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MultiBlocListener(
      listeners: [
        BlocListener<TransactionDetailBloc, TransactionDetailState>(
          listenWhen: (previous, current) =>
              current.isClosed && !previous.isClosed,
          listener: _close,
        ),
        BlocListener<TransactionDetailBloc, TransactionDetailState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: c.background,
        appBar: MonAITopBar(
          title: l10n.transactionDetailTitle,
          placement: placement,
          titleStyle: context.textTheme.titleMedium,
          actions: [
            BlocSelector<TransactionDetailBloc, TransactionDetailState, bool>(
              selector: (state) => state.status == .success,
              builder: (context, loaded) => Row(
                children: [
                  MonAIIconButton(
                    icon: MonAIIcons.edit,
                    tooltip: l10n.transactionDetailEditTooltip,
                    onPressed: loaded ? () => _edit(context) : null,
                  ),
                  MonAIIconButton(
                    icon: MonAIIcons.delete,
                    tooltip: l10n.transactionDetailDeleteTooltip,
                    color: c.error,
                    onPressed: loaded ? () => _delete(context) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        body:
            BlocSelector<
              TransactionDetailBloc,
              TransactionDetailState,
              UiStatus
            >(
              selector: (state) => state.status,
              builder: (context, status) => switch (status) {
                .initial || .loading => Center(
                  child: Semantics(
                    label: l10n.transactionDetailLoading,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                .failure => _LoadError(onRetry: () => _retry(context)),
                .success || .empty => _Content(
                  onEdit: () => _edit(context),
                  onDelete: () => _delete(context),
                ),
              },
            ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x10),
        child:
            BlocSelector<
              TransactionDetailBloc,
              TransactionDetailState,
              TransactionFailure?
            >(
              selector: (state) => state.loadFailure,
              builder: (context, failure) => MonAIStateMessage(
                icon: failure == .network
                    ? MonAIIcons.cloudOff
                    : MonAIIcons.error,
                tone: .error,
                title: l10n.transactionDetailLoadErrorTitle,
                message: (failure ?? .unexpected).message(l10n),
                // A transaction that is gone won't come back on retry.
                actionLabel: failure == .notFound
                    ? null
                    : l10n.transactionsRetry,
                actionIcon: MonAIIcons.refresh,
                onAction: onRetry,
              ),
            ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  void _viewReceipt(BuildContext context, String url) =>
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => TransactionReceiptViewer(url: url),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
      buildWhen: (previous, current) =>
          previous.transaction != current.transaction ||
          previous.lookups != current.lookups ||
          previous.isDeleting != current.isDeleting,
      builder: (context, state) {
        final transaction = state.transaction;
        if (transaction == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const .symmetric(
                  horizontal: MonAISpacing.screenHorizontal,
                  vertical: MonAISpacing.x2,
                ),
                children: [
                  TransactionDetailHero(
                    transaction: transaction,
                    lookups: state.lookups,
                  ),
                  const SizedBox(height: MonAISpacing.x4),
                  TransactionDetailFields(
                    transaction: transaction,
                    lookups: state.lookups,
                  ),
                  if (transaction.receiptUrl case final url?) ...[
                    const SizedBox(height: MonAISpacing.x4),
                    TransactionDetailReceipt(
                      url: url,
                      onView: () => _viewReceipt(context, url),
                    ),
                  ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const .fromLTRB(
                  MonAISpacing.screenHorizontal,
                  MonAISpacing.x2,
                  MonAISpacing.screenHorizontal,
                  MonAISpacing.x6,
                ),
                child: Row(
                  spacing: MonAISpacing.x3,
                  children: [
                    Expanded(
                      child: MonAIButton(
                        label: l10n.transactionsDelete,
                        leadingIcon: MonAIIcons.delete,
                        variant: .destructive,
                        size: .medium,
                        loading: state.isDeleting,
                        expand: true,
                        onPressed: onDelete,
                      ),
                    ),
                    Expanded(
                      child: MonAIButton(
                        label: l10n.transactionDetailEdit,
                        leadingIcon: MonAIIcons.edit,
                        size: .medium,
                        expand: true,
                        onPressed: onEdit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
