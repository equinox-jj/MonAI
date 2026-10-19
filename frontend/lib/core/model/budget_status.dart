/// A month's spending against its budget, as calculated by the server.
enum BudgetStatus {
  /// Below 80% of the limit.
  ok,

  /// At 80% or more of the limit.
  warning,

  /// Above 100% of the limit.
  exceeded,
}
