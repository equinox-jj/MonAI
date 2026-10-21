import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/undo_delete/cubit/undo_delete_cubit.dart';

/// Wraps the signed-in screens: after any transaction is deleted, a snackbar
/// offers to undo it for a few seconds.
class UndoDeleteHost extends StatelessWidget {
  const UndoDeleteHost({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UndoDeleteCubit>()..started(),
      child: UndoDeleteListener(child: child),
    );
  }
}

/// Shows the undo and restore-failure snackbars of the [UndoDeleteCubit]
/// above it.
class UndoDeleteListener extends StatelessWidget {
  const UndoDeleteListener({required this.child, super.key});

  final Widget child;

  void _offerUndo(BuildContext context, UndoDeleteState state) {
    final deleted = state.deleted;
    if (deleted == null) return;
    final cubit = context.read<UndoDeleteCubit>();
    final l10n = context.l10n;
    final controller = showMonAISnackBar(
      context,
      message: l10n.undoDeleted(deleted.titleText(l10n, state.lookups)),
      icon: MonAIIcons.delete,
      actionLabel: l10n.undoAction,
      onAction: cubit.undo,
      duration: UndoDeleteCubit.undoWindow,
    );
    controller.closed.then((reason) {
      if (reason != SnackBarClosedReason.action) cubit.dismissed();
    });
  }

  void _showRestoreFailure(BuildContext context, UndoDeleteState state) {
    final failure = state.restoreFailure;
    if (failure == null) return;
    final l10n = context.l10n;
    showMonAISnackBar(
      context,
      message: failure == .unexpected
          ? l10n.undoRestoreFailed
          : failure.message(l10n),
      icon: failure == .network ? MonAIIcons.cloudOff : MonAIIcons.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UndoDeleteCubit, UndoDeleteState>(
          listenWhen: (previous, current) =>
              current.deleted != null && previous.deleted != current.deleted,
          listener: _offerUndo,
        ),
        BlocListener<UndoDeleteCubit, UndoDeleteState>(
          listenWhen: (previous, current) =>
              current.restoreFailure != null &&
              previous.restoreFailure != current.restoreFailure,
          listener: _showRestoreFailure,
        ),
      ],
      child: child,
    );
  }
}
