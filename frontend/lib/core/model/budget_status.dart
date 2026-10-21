enum BudgetStatus {
  /// Below 80% of the limit.
  ok,

  /// At 80% or more of the limit.
  warning,

  /// Above 100% of the limit.
  exceeded,
}
