part of 'budget_bloc.dart';

/// How the screen closed.
enum BudgetOutcome { saved, removed }

@freezed
abstract class BudgetState with _$BudgetState {
  const factory BudgetState({
    /// The first of the month.
    required DateTime month,

    /// The saved budget; null when the month has none.
    Budget? budget,

    /// The month's spending from the report, for a month without a budget.
    int? reportSpent,

    /// The limit in the field, in rupiah; 0 when empty.
    @Default(0) int limit,

    /// The user changed the limit: a budget loading late no longer fills it.
    @Default(false) bool limitTouched,

    /// The limit's error, shown under the field.
    FieldError? limitError,

    /// A save failed on the limit, so its error updates as the user types.
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,

    /// Set once saved or removed; the screen closes.
    BudgetOutcome? outcome,

    /// Why a save or remove failed; shown once as a snackbar.
    BudgetFailure? actionFailure,
  }) = _BudgetState;
}

extension BudgetStateX on BudgetState {
  bool get hasBudget => budget != null;

  bool get isBusy => isSaving || isDeleting;

  /// The month's spending so far.
  int get spent => budget?.spent ?? reportSpent ?? 0;

  /// The limit in the field against [spent]; null while it's empty.
  BudgetPreview? get preview => BudgetPreview.of(limit: limit, spent: spent);

  bool get canSave => limit > 0 && !isBusy;
}
