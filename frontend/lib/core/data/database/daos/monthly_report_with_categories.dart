import 'package:monai/core/data/database/monai_database.dart';

typedef MonthlyReportWithCategories = ({
  MonthlyReportRow report,
  List<ReportCategoryRow> categories,
});
