part of 'transaction_form_bloc.dart';

@freezed
abstract class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    required TransactionFormMode mode,
    required DateTime today,
    required TransactionDraft draft,

    /// What the form started with, to tell whether anything changed.
    required TransactionDraft baseline,
    @Default(UiStatus.initial) UiStatus status,
    Transaction? original,
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default({}) Map<String, FieldError> errors,

    /// Fields a quick-add draft filled unsurely, keyed by the API's field
    /// name; each is marked until the user changes it.
    @Default({}) Set<String> unsure,
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,
    @Default(false) bool askDiscard,
    TransactionFormOutcome? outcome,
    TransactionFailure? loadFailure,
    TransactionFailure? actionFailure,
  }) = _TransactionFormState;
}

extension TransactionFormStateX on TransactionFormState {
  bool get isEdit => mode is EditTransactionMode;

  String get initialNote => switch (mode) {
    PrefillTransactionMode(:final draft) => draft.note ?? '',
    _ => original?.note ?? '',
  };

  bool isUnsure(String field) => unsure.contains(field);

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

  List<Wallet> get wallets {
    final keep = {original?.walletId, original?.toWalletId};
    return lookups.wallets.values
        .where((w) => !w.isArchived || keep.contains(w.id))
        .toList();
  }

  int? get changedFromAmount => switch (original) {
    final original? when original.amount != draft.amount => original.amount,
    _ => null,
  };

  FieldError? errorOf(String field) => errors[field];
}
