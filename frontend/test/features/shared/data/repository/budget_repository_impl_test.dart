import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/budget_status.dart';
import 'package:monai/features/shared/data/datasources/budget_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/budget_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/budget_mapper.dart';
import 'package:monai/features/shared/data/model/budget_response.dart';
import 'package:monai/features/shared/data/model/set_budget_request.dart';
import 'package:monai/features/shared/data/repository/budget_repository_impl.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements BudgetRemoteDataSource {}

class _MockLocal extends Mock implements BudgetLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late BudgetRepositoryImpl repository;
  final october = DateTime(2026, 10);

  setUpAll(() {
    registerFallbackValue(budgetRow());
    registerFallbackValue(const SetBudgetRequest(limitAmount: 0));
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = BudgetRepositoryImpl(remote: remote, local: local);
    when(() => local.upsert(any())).thenAnswer((_) async {});
    when(() => local.deleteByMonth(any())).thenAnswer((_) async {});
  });

  test('caches the month budget', () async {
    // Arrange
    when(
      () => remote.getBudget('2026-10'),
    ).thenAnswer((_) async => BudgetResponse.fromJson(envelope(budgetJson())));

    // Act
    final result = await repository.refreshBudget(october);

    // Assert
    final row =
        verify(() => local.upsert(captureAny())).captured.single as BudgetRow;
    expect(result, Right<Failure, Budget?>(row.toEntity()));
    expect(row.month, october);
    expect(row.status, BudgetStatus.warning);
    expect(row.progressPercent, 85.0);
  });

  test(
    'a month without a budget succeeds with null and clears the cache',
    () async {
      // Arrange
      when(() => remote.getBudget('2026-10'))
          .thenThrow(const NotFoundException(code: 'not_found'));

      // Act
      final result = await repository.refreshBudget(october);

      // Assert
      expect(result, const Right<Failure, Budget?>(null));
      verify(() => local.deleteByMonth(october)).called(1);
    },
  );

  test('a network failure keeps the cached budget', () async {
    // Arrange
    when(() => remote.getBudget('2026-10')).thenThrow(const NetworkException());

    // Act
    final result = await repository.refreshBudget(october);

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    verifyNever(() => local.deleteByMonth(any()));
  });

  test('watchBudget maps the cached row', () async {
    // Arrange
    when(() => local.watch(october))
        .thenAnswer((_) => Stream.value(budgetRow(limitAmount: 500)));

    // Act
    final result = await repository.watchBudget(october).first;

    // Assert
    expect(result.getRight().toNullable()?.limitAmount, 500);
  });

  test('setBudget sends the limit and caches the result', () async {
    // Arrange
    when(
      () => remote.setBudget(
        '2026-10',
        const SetBudgetRequest(limitAmount: 1000000),
      ),
    ).thenAnswer((_) async => BudgetResponse.fromJson(envelope(budgetJson())));

    // Act
    final result = await repository.setBudget(october, 1000000);

    // Assert
    final row =
        verify(() => local.upsert(captureAny())).captured.single as BudgetRow;
    expect(result, Right<Failure, Budget>(row.toEntity()));
    expect(row.limitAmount, 1000000);
  });

  test('setBudget failing leaves the cache alone', () async {
    // Arrange
    when(() => remote.setBudget(any(), any()))
        .thenThrow(const NetworkException());

    // Act
    final result = await repository.setBudget(october, 1000000);

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    verifyNever(() => local.upsert(any()));
  });

  test('deleteBudget removes it on the server and in the cache', () async {
    // Arrange
    when(() => remote.deleteBudget('2026-10')).thenAnswer((_) async {});

    // Act
    final result = await repository.deleteBudget(october);

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(() => local.deleteByMonth(october)).called(1);
  });

  test('deleteBudget treats an already removed budget as done', () async {
    // Arrange
    when(() => remote.deleteBudget('2026-10'))
        .thenThrow(const NotFoundException(code: 'not_found'));

    // Act
    final result = await repository.deleteBudget(october);

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(() => local.deleteByMonth(october)).called(1);
  });

  test('deleteBudget failing keeps the cached budget', () async {
    // Arrange
    when(() => remote.deleteBudget('2026-10'))
        .thenThrow(const NetworkException());

    // Act
    final result = await repository.deleteBudget(october);

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    verifyNever(() => local.deleteByMonth(any()));
  });
}
