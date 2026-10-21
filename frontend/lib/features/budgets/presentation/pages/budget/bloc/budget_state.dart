part of 'budget_bloc.dart';

enum BudgetOutcome { saved, removed }

@freezed
abstract class BudgetState with _$BudgetState {
  const factory BudgetState({
    required DateTime month,
    Budget? budget,
    int? reportSpent,
    @Default(0) int limit,

    /// The user changed the limit: a budget loading late no longer fills it.
    @Default(false) bool limitTouched,
    FieldError? limitError,
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,
    BudgetOutcome? outcome,
    BudgetFailure? actionFailure,
  }) = _BudgetState;
}

extension BudgetStateX on BudgetState {
  bool get hasBudget => budget != null;

  bool get isBusy => isSaving || isDeleting;

  int get spent => budget?.spent ?? reportSpent ?? 0;

  BudgetPreview? get preview => BudgetPreview.of(limit: limit, spent: spent);

  bool get canSave => limit > 0 && !isBusy;
}
