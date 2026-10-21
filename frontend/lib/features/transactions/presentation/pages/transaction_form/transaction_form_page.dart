import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/app_router.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_field_error_text.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_amount.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_category.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_fields.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_keypad.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_type_tabs.dart';

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({
    required this.mode,
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final TransactionFormMode mode;
  final ScreenPlacement placement;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TransactionFormBloc>(param1: mode)
            ..add(const TransactionFormEvent.started()),
      child: TransactionFormUI(placement: placement),
    );
  }
}

class TransactionFormUI extends StatefulWidget {
  const TransactionFormUI({
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final ScreenPlacement placement;

  @override
  State<TransactionFormUI> createState() => _TransactionFormUIState();
}

class _TransactionFormUIState extends State<TransactionFormUI> {
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The edited transaction may have loaded before this screen listened.
    _note.text = _bloc.state.initialNote;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  TransactionFormBloc get _bloc => context.read<TransactionFormBloc>();

  void _save() =>
      _bloc.add(TransactionFormEvent.saveRequested(note: _note.text));

  void _close() =>
      _bloc.add(TransactionFormEvent.closeRequested(note: _note.text));

  void _delete() => _bloc.add(const TransactionFormEvent.deleteRequested());

  void _scan() =>
      _bloc.add(TransactionFormEvent.scanRequested(note: _note.text));

  void _retry() => _bloc.add(const TransactionFormEvent.retried());

  void _onPopInvoked(bool didPop, Object? result) {
    if (!didPop) _close();
  }

  void _fillNote(BuildContext context, TransactionFormState state) =>
      _note.text = state.original?.note ?? '';

  void _finish(BuildContext context, TransactionFormState state) =>
      switch (state.outcome) {
        ScanReceiptFormOutcome() => context.pushReplacement(
          AppRoutes.receiptScan,
        ),
        final outcome => Navigator.pop(context, outcome),
      };

  Future<void> _askDiscard(
    BuildContext context,
    TransactionFormState state,
  ) async {
    final l10n = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => MonAIAlertDialog(
        title: l10n.transactionFormDiscardTitle,
        message: l10n.transactionFormDiscardBody,
        confirmLabel: l10n.transactionFormDiscard,
        destructive: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
        dismissLabel: l10n.transactionFormKeepEditing,
        onDismiss: () => Navigator.pop(dialogContext, false),
      ),
    );
    if (discard ?? false) {
      _bloc.add(const TransactionFormEvent.discardConfirmed());
    }
  }

  void _showActionFailure(BuildContext context, TransactionFormState state) {
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
        BlocListener<TransactionFormBloc, TransactionFormState>(
          listenWhen: (previous, current) =>
              current.original != null && previous.original != current.original,
          listener: _fillNote,
        ),
        BlocListener<TransactionFormBloc, TransactionFormState>(
          listenWhen: (previous, current) =>
              current.outcome != null && previous.outcome == null,
          listener: _finish,
        ),
        BlocListener<TransactionFormBloc, TransactionFormState>(
          listenWhen: (previous, current) =>
              current.askDiscard && !previous.askDiscard,
          listener: _askDiscard,
        ),
        BlocListener<TransactionFormBloc, TransactionFormState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvoked,
        child: Scaffold(
          backgroundColor: c.surface,
          // The body keeps the keyboard inset so the keypad can hide;
          // _KeyboardSpace lifts the form above the keyboard instead.
          resizeToAvoidBottomInset: false,
          appBar: MonAITopBar(
            title:
                context.select<TransactionFormBloc, bool>(
                  (bloc) => bloc.state.isEdit,
                )
                ? l10n.transactionFormEditTitle
                : l10n.transactionFormNewTitle,
            navigation: .close,
            onNavigationPressed: _close,
            placement: widget.placement,
            actions: [
              BlocSelector<TransactionFormBloc, TransactionFormState, bool>(
                selector: (state) => state.mode is AddTransactionMode,
                builder: (context, canScan) => canScan
                    ? Padding(
                        padding: const .only(right: MonAISpacing.x2),
                        child: MonAIButton(
                          label: l10n.transactionFormScan,
                          leadingIcon: MonAIIcons.documentScanner,
                          onPressed: _scan,
                          variant: .tonal,
                          size: .small,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              BlocSelector<
                TransactionFormBloc,
                TransactionFormState,
                (bool, bool)
              >(
                selector: (state) => (
                  state.isEdit && state.status == .success,
                  state.isDeleting,
                ),
                builder: (context, selected) => switch (selected) {
                  (true, final isDeleting) => MonAIIconButton(
                    icon: MonAIIcons.delete,
                    tooltip: l10n.transactionDetailDeleteTooltip,
                    color: c.error,
                    onPressed: isDeleting ? null : _delete,
                  ),
                  (false, _) => const SizedBox.shrink(),
                },
              ),
            ],
          ),
          body:
              BlocSelector<TransactionFormBloc, TransactionFormState, UiStatus>(
                selector: (state) => state.status,
                builder: (context, status) => switch (status) {
                  .initial ||
                  .loading => const Center(child: CircularProgressIndicator()),
                  .failure => _LoadError(onRetry: _retry),
                  .success || .empty => _FormBody(note: _note, onSave: _save),
                },
              ),
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
              TransactionFormBloc,
              TransactionFormState,
              TransactionFailure?
            >(
              selector: (state) => state.loadFailure,
              builder: (context, failure) => MonAIStateMessage(
                icon: MonAIIcons.error,
                tone: .error,
                title: l10n.transactionDetailLoadErrorTitle,
                message: (failure ?? .unexpected).message(l10n),
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

class _FormBody extends StatelessWidget {
  const _FormBody({required this.note, required this.onSave});

  final TextEditingController note;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const .fromLTRB(
          MonAISpacing.screenHorizontal,
          MonAISpacing.x1,
          MonAISpacing.screenHorizontal,
          MonAISpacing.x4,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: MonAISpacing.x3,
                  children: [
                    const _QuickAddNote(),
                    const TransactionFormTypeTabs(),
                    const TransactionFormAmount(),
                    BlocSelector<
                      TransactionFormBloc,
                      TransactionFormState,
                      bool
                    >(
                      selector: (state) =>
                          state.draft.type != TransactionType.transfer,
                      builder: (context, hasCategory) => hasCategory
                          ? const TransactionFormCategory()
                          : const SizedBox.shrink(),
                    ),
                    const TransactionFormFields(),
                    _NoteField(controller: note),
                    const _EditNote(),
                  ],
                ),
              ),
            ),
            const _Keypad(),
            const SizedBox(height: MonAISpacing.x3),
            _SaveButton(onSave: onSave),
            const _KeyboardSpace(),
          ],
        ),
      ),
    );
  }
}

class _QuickAddNote extends StatelessWidget {
  const _QuickAddNote();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionFormBloc, TransactionFormState, bool>(
      selector: (state) =>
          state.mode is PrefillTransactionMode && state.unsure.isNotEmpty,
      builder: (context, show) => show
          ? MonAIInlineAlert(
              message: context.l10n.transactionFormQuickAddCheck,
              tone: .warning,
            )
          : const SizedBox.shrink(),
    );
  }
}

/// Only the note opens the keyboard; hide the keypad meanwhile so the two
/// don't stack.
class _Keypad extends StatelessWidget {
  const _Keypad();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.viewInsetsOf(context).bottom > 0) {
      return const SizedBox.shrink();
    }
    return const Padding(
      padding: .only(top: MonAISpacing.x2),
      child: TransactionFormKeypad(),
    );
  }
}

class _KeyboardSpace extends StatelessWidget {
  const _KeyboardSpace();

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: MediaQuery.viewInsetsOf(context).bottom);
}

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<TransactionFormBloc, TransactionFormState, FieldError?>(
      selector: (state) => state.errorOf(TransactionInputValidator.noteField),
      builder: (context, error) => MonAITextField(
        controller: controller,
        placeholder: l10n.transactionFormNoteHint,
        leadingIcon: MonAIIcons.editNote,
        textInputAction: TextInputAction.done,
        compact: true,
        tone: error == null ? .neutral : .error,
        supportingText: error?.text(l10n),
      ),
    );
  }
}

class _EditNote extends StatelessWidget {
  const _EditNote();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionFormBloc, TransactionFormState, bool>(
      selector: (state) => state.isEdit,
      builder: (context, isEdit) => isEdit
          ? MonAIInlineAlert(
              message: context.l10n.transactionFormUpdateNote,
              icon: MonAIIcons.info,
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      TransactionFormBloc,
      TransactionFormState,
      (TransactionType, bool, bool)
    >(
      selector: (state) => (state.draft.type, state.isEdit, state.isSaving),
      builder: (context, selected) {
        final (type, isEdit, isSaving) = selected;
        return MonAIButton(
          label: isEdit
              ? l10n.transactionFormSaveChanges
              : switch (type) {
                  .expense => l10n.transactionFormSaveExpense,
                  .income => l10n.transactionFormSaveIncome,
                  .transfer => l10n.transactionFormSaveTransfer,
                },
          leadingIcon: MonAIIcons.check,
          loading: isSaving,
          expand: true,
          onPressed: onSave,
        );
      },
    );
  }
}
