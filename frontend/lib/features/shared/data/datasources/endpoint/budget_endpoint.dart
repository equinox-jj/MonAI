/// Budget API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class BudgetEndpoint {
  /// `GET`: the budget for [month] (`yyyy-MM`).
  static String budget(String month) => '/budgets/$month';
}
