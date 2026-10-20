part of 'transaction_form_bloc.dart';

@freezed
abstract class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    required TransactionFormMode mode,

    /// The user's current date; later dates can't be picked.
    required DateTime today,

    /// What is entered now.
    required TransactionDraft draft,

    /// What the form started with, to tell whether anything changed.
    required TransactionDraft baseline,

    /// [UiStatus.loading] while the edited transaction loads,
    /// [UiStatus.failure] when it couldn't be, otherwise
    /// [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// The transaction being edited.
    Transaction? original,
    @Default(TransactionLookups()) TransactionLookups lookups,

    /// One error per invalid field, keyed by the API's field name.
    @Default({}) Map<String, FieldError> errors,

    /// A save failed on the input, so errors update as the user edits.
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,

    /// Close was asked with unsaved changes: the discard dialog shows once.
    @Default(false) bool askDiscard,

    /// Set once the form is done; the screen closes.
    TransactionFormOutcome? outcome,

    /// Why the edited transaction couldn't be loaded.
    TransactionFailure? loadFailure,

    /// Why a save or delete failed; shown once as a snackbar.
    TransactionFailure? actionFailure,
  }) = _TransactionFormState;
}

extension TransactionFormStateX on TransactionFormState {
  bool get isEdit => mode is EditTransactionMode;

  /// The categories of the draft's type to pick from; the edited
  /// transaction's own stays even when hidden.
  List<Category> get categories {
    final type = switch (draft.type) {
      .income => CategoryType.income,
      .expense || .transfer => CategoryType.expense,
    };
    final keep = original?.categoryId;
    return lookups.categories.values
        .where((c) => c.type == type && (!c.isHidden || c.id == keep))
        .toList();
  }

  /// Wallets that can be picked; the edited transaction's own stay even
  /// when archived.
  List<Wallet> get wallets {
    final keep = {original?.walletId, original?.toWalletId};
    return lookups.wallets.values
        .where((w) => !w.isArchived || keep.contains(w.id))
        .toList();
  }

  /// The saved amount, shown as "Was Rp 35.000" once the amount changes.
  int? get changedFromAmount => switch (original) {
    final original? when original.amount != draft.amount => original.amount,
    _ => null,
  };

  FieldError? errorOf(String field) => errors[field];
}
