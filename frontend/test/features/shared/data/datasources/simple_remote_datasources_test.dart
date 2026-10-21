import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/features/shared/data/datasources/budget_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/endpoint/category_endpoint.dart';
import 'package:monai/features/shared/data/datasources/endpoint/report_endpoint.dart';
import 'package:monai/features/shared/data/datasources/endpoint/user_endpoint.dart';
import 'package:monai/features/shared/data/datasources/report_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_remote_datasource.dart';

import '../../../../helpers/api_fixtures.dart';

class _MockDio extends Mock implements Dio {}

// The single-GET data sources: category, budget, report and user.
void main() {
  late _MockDio dio;

  setUp(() => dio = _MockDio());

  void stubGet(Map<String, dynamic> body) => when(
    () => dio.get<Map<String, dynamic>>(
      any(),
      queryParameters: any(named: 'queryParameters'),
    ),
  ).thenAnswer((invocation) async => okResponse('', body));

  test('categories are fetched with hidden ones', () async {
    // Arrange
    stubGet(envelope([categoryJson()]));

    // Act
    final response = await CategoryRemoteDataSourceImpl(dio: dio)
        .getCategories();

    // Assert
    verify(
      () => dio.get<Map<String, dynamic>>(
        CategoryEndpoint.categories,
        queryParameters: {'include_hidden': true},
      ),
    ).called(1);
    expect(response.data?.single.isHidden, isFalse);
  });

  test('a budget is fetched by month', () async {
    // Arrange
    stubGet(envelope(budgetJson()));

    // Act
    final response = await BudgetRemoteDataSourceImpl(dio: dio)
        .getBudget('2026-10');

    // Assert
    verify(() => dio.get<Map<String, dynamic>>('/budgets/2026-10')).called(1);
    expect(response.data?.progressPercent, 85);
  });

  test('a month without a budget fails as not found', () async {
    // Arrange
    when(() => dio.get<Map<String, dynamic>>(any()))
        .thenThrow(errorResponse('/budgets/2026-10', 404, 'not_found'));

    // Act
    final call = BudgetRemoteDataSourceImpl(dio: dio).getBudget('2026-10');

    // Assert
    await expectLater(call, throwsA(isA<NotFoundException>()));
  });

  test('a monthly report is fetched with the month as a query', () async {
    // Arrange
    stubGet(envelope(monthlyReportJson()));

    // Act
    final response = await ReportRemoteDataSourceImpl(dio: dio)
        .getMonthlyReport('2026-10');

    // Assert
    verify(
      () => dio.get<Map<String, dynamic>>(
        ReportEndpoint.monthly,
        queryParameters: {'month': '2026-10'},
      ),
    ).called(1);
    expect(response.data?.categories, hasLength(2));
    expect(response.data?.previous?.month, '2026-09');
  });

  test('the user is fetched from /me', () async {
    // Arrange
    stubGet(envelope(meJson()));

    // Act
    final response = await UserRemoteDataSourceImpl(dio: dio).getMe();

    // Assert
    verify(() => dio.get<Map<String, dynamic>>(UserEndpoint.me)).called(1);
    expect(response.data?.role?.slug, 'user');
  });
}
