import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/export/data/datasources/export_local_datasource.dart';
import 'package:monai/features/export/data/repository/export_repository_impl.dart';
import 'package:monai/features/shared/data/datasources/transaction_remote_datasource.dart';
import 'package:monai/features/shared/data/model/transaction_list_response.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';

import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements TransactionRemoteDataSource {}

class _MockLocal extends Mock implements ExportLocalDataSource {}

TransactionData _data(String id) => TransactionData.fromJson({
  'id': id,
  'type': 'EXPENSE',
  'amount': 1000,
  'wallet_id': 'w1',
  'to_wallet_id': null,
  'category_id': 'c1',
  'date': '2026-10-01',
  'note': null,
  'merchant': null,
  'receipt_url': null,
  'source': 'MANUAL',
  'created_at': '2026-10-01T08:00:00Z',
  'updated_at': '2026-10-01T08:00:00Z',
});

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late ExportRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const TransactionQuery(month: '', limit: 0));
    registerFallbackValue(<Never>[]);
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = ExportRepositoryImpl(remote: remote, local: local);
    when(() => local.cache(any())).thenAnswer((_) async {});
  });

  test('pages through a month, caching each page', () async {
    // Arrange
    final queries = <TransactionQuery>[];
    when(() => remote.getTransactions(any())).thenAnswer((invocation) async {
      final query = invocation.positionalArguments.single as TransactionQuery;
      queries.add(query);
      return query.cursor == null
          ? TransactionListResponse(
              data: [_data('t1'), _data('t2')],
              meta: const TransactionListMeta(nextCursor: 'c2', hasMore: true),
            )
          : TransactionListResponse(
              data: [_data('t3')],
              meta: const TransactionListMeta(hasMore: false),
            );
    });

    // Act
    final result = await repository.fetchMonth(DateTime(2026, 10));

    // Assert
    expect(result.getOrElse((_) => const []).map((t) => t.id), [
      't1',
      't2',
      't3',
    ]);
    expect(queries.map((q) => (q.month, q.limit, q.cursor)), [
      ('2026-10', ExportRepositoryImpl.pageSize, null),
      ('2026-10', ExportRepositoryImpl.pageSize, 'c2'),
    ]);
    verify(() => local.cache(any())).called(2);
  });

  test('a failed page fails the month', () async {
    // Arrange
    when(() => remote.getTransactions(any()))
        .thenThrow(const NetworkException());

    // Act
    final result = await repository.fetchMonth(DateTime(2026, 10));

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });

  test('reads cached transactions between two days', () async {
    // Arrange
    when(() => local.between(any(), any()))
        .thenAnswer((_) async => [transactionRow()]);

    // Act
    final result = await repository.cachedBetween(
      DateTime(2026, 10),
      DateTime(2026, 10, 31),
    );

    // Assert
    expect(result.getOrElse((_) => const []), hasLength(1));
  });

  test('writing the file gives its path', () async {
    // Arrange
    when(() => local.writeExport(any(), any()))
        .thenAnswer((_) async => '/tmp/exports/a.csv');

    // Act
    final result = await repository.writeFile('a.csv', 'x');

    // Assert
    expect(result, const Right<Failure, String>('/tmp/exports/a.csv'));
  });
}
