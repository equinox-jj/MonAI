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
