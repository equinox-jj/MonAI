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
