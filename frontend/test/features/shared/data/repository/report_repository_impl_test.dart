import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/data/database/daos/monthly_report_with_categories.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/data/datasources/report_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/report_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/monthly_report_mapper.dart';
import 'package:monai/features/shared/data/model/monthly_report_response.dart';
import 'package:monai/features/shared/data/repository/report_repository_impl.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements ReportRemoteDataSource {}

class _MockLocal extends Mock implements ReportLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late ReportRepositoryImpl repository;
  final october = DateTime(2026, 10);

  setUpAll(
    () => registerFallbackValue((
      report: monthlyReportRow(),
      categories: [reportCategoryRow()],
    )),
  );

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = ReportRepositoryImpl(remote: remote, local: local);
  });

  test('caches the report with its breakdown in server order', () async {
    // Arrange
    when(() => remote.getMonthlyReport('2026-10')).thenAnswer(
      (_) async =>
          MonthlyReportResponse.fromJson(envelope(monthlyReportJson())),
    );
    when(() => local.replace(any())).thenAnswer((_) async {});

    // Act
    final result = await repository.refreshMonthlyReport(october);

    // Assert
    final rows =
        verify(() => local.replace(captureAny())).captured.single
            as MonthlyReportWithCategories;
    expect(result, Right<Failure, MonthlyReport>(rows.toEntity()));
    expect(rows.report.month, october);
    expect(rows.report.previousMonth, DateTime(2026, 9));
    expect(rows.categories.map((row) => (row.categoryId, row.position)), [
      ('c2', 0),
      ('c1', 1),
    ]);
    expect(rows.categories.first.changePercent, isNull);
  });

  test('watchMonthlyReport maps the cached report', () async {
    // Arrange
    when(() => local.watch(october)).thenAnswer(
      (_) => Stream.value((
        report: monthlyReportRow(),
        categories: [reportCategoryRow()],
      )),
    );

    // Act
    final result = await repository.watchMonthlyReport(october).first;

    // Assert
    final report = result.getRight().toNullable();
    expect(report?.previous.expenseTotal, 100000);
    expect(report?.categories.single.name, 'Food');
  });

  test(
    'watchExpenseTotals gives the expense of each cached month of the year',
    () async {
      // Arrange
      when(() => local.watchBetween(DateTime(2026), DateTime(2026, 12)))
          .thenAnswer(
            (_) => Stream.value([
              monthlyReportRow(month: DateTime(2026, 9)),
              monthlyReportRow(),
            ]),
          );

      // Act
      final result = await repository.watchExpenseTotals(2026).first;

      // Assert
      expect(result.getRight().toNullable(), {
        DateTime(2026, 9): 200000,
        DateTime(2026, 10): 200000,
      });
    },
  );
}
