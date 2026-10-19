/// Report API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class ReportEndpoint {
  /// `GET`: one month's totals and expense breakdown (`?month=yyyy-MM`).
  static const monthly = '/reports/monthly';
}
