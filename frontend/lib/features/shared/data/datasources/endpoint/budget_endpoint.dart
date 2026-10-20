/// Budget API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class BudgetEndpoint {
  /// `GET`, `PUT`, `DELETE`: the budget for [month] (`yyyy-MM`).
  static String budget(String month) => '/budgets/$month';
}
