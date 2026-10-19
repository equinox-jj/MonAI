import 'package:monai/core/database/monai_database.dart';

/// A cached monthly report with its expense breakdown, in the server's order.
typedef MonthlyReportWithCategories = ({
  MonthlyReportRow report,
  List<ReportCategoryRow> categories,
});
