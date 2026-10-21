import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/data/datasources/transaction_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/transaction_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/transaction_mapper.dart';
import 'package:monai/features/shared/data/model/attach_receipt_request.dart';
import 'package:monai/features/shared/data/model/receipt_upload_response.dart';
import 'package:monai/features/shared/data/model/transaction_list_response.dart';
import 'package:monai/features/shared/data/model/transaction_request.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';
import 'package:monai/features/shared/data/repository/transaction_repository_impl.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements TransactionRemoteDataSource {}

class _MockLocal extends Mock implements TransactionLocalDataSource {}

TransactionListResponse _page(List<String> ids, {String? nextCursor}) =>
    TransactionListResponse.fromJson(
      envelope(
        [for (final id in ids) transactionJson(id: id)],
        meta: {
          'next_cursor': nextCursor,
          'has_more': nextCursor != null,
          'limit': 20,
        },
      ),
    );

TransactionResponse _one({String id = 't1', String date = '2026-10-01'}) =>
    TransactionResponse.fromJson(envelope(transactionJson(id: id, date: date)));

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late TransactionRepositoryImpl repository;
  final october = DateTime(2026, 10);
  const filter = TransactionFilter(type: TransactionType.expense);

  setUpAll(() {
    registerFallbackValue(const TransactionQuery(month: '', limit: 0));
    registerFallbackValue(const TransactionFilter());
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(
      const TransactionRequest(type: '', amount: 0, walletId: '', date: ''),
    );
    registerFallbackValue(const AttachReceiptRequest(receiptKey: ''));
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = TransactionRepositoryImpl(remote: remote, local: local);
    when(() => local.upsertAll(any())).thenAnswer((_) async {});
    when(() => local.deleteById(any())).thenAnswer((_) async {});
    when(
      () => local.replaceFirstPage(
        any(),
        any(),
        any(),
        nextCursor: any(named: 'nextCursor'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => local.appendPage(
        any(),
        any(),
        any(),
        nextCursor: any(named: 'nextCursor'),
      ),
    ).thenAnswer((_) async {});
  });

  group('recent', () {
    test('refresh fetches the month and replaces what it covers', () async {
      // Arrange
      when(() => remote.getTransactions(any()))
          .thenAnswer((_) async => _page(['t1', 't2'], nextCursor: 'abc'));
      when(
        () => local.replaceRecent(any(), any(), hasMore: any(named: 'hasMore')),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.refreshRecentTransactions(
        october,
        limit: 5,
      );

      // Assert
      final query =
          verify(() => remote.getTransactions(captureAny())).captured.single
              as TransactionQuery;
      expect(query.toQueryParameters(), {'month': '2026-10', 'limit': 5});
      final rows =
          verify(
                () => local.replaceRecent(october, captureAny(), hasMore: true),
              ).captured.single
              as List<TransactionRow>;
      expect(rows.map((row) => row.id), ['t1', 't2']);
      expect(
        result.getRight().toNullable(),
        rows.map((row) => row.toEntity()).toList(),
      );
    });
  });

  group('paging', () {
    test('refresh loads the first page with the filter', () async {
      // Arrange
      when(() => remote.getTransactions(any()))
          .thenAnswer((_) async => _page(['t1'], nextCursor: 'abc'));

      // Act
      final result = await repository.refreshTransactions(october, filter);

      // Assert
      expect(result, const Right<Failure, bool>(true));
      final query =
          verify(() => remote.getTransactions(captureAny())).captured.single
              as TransactionQuery;
      expect(query.toQueryParameters(), {
        'month': '2026-10',
        'limit': 20,
        'type': 'EXPENSE',
      });
      verify(
        () => local.replaceFirstPage(october, filter, any(), nextCursor: 'abc'),
      ).called(1);
    });

    test('the last page stores no cursor', () async {
      // Arrange
      when(() => remote.getTransactions(any()))
          .thenAnswer((_) async => _page(['t1']));

      // Act
      final result = await repository.refreshTransactions(october, filter);

      // Assert
      expect(result, const Right<Failure, bool>(false));
      verify(
        () => local.replaceFirstPage(october, filter, any(), nextCursor: null),
      ).called(1);
    });

    test('load more before any page loads the first one', () async {
      // Arrange
      when(() => local.remoteKey(any(), any())).thenAnswer((_) async => null);
      when(() => remote.getTransactions(any()))
          .thenAnswer((_) async => _page(['t1'], nextCursor: 'abc'));

      // Act
      final result = await repository.loadMoreTransactions(october, filter);

      // Assert
      expect(result, const Right<Failure, bool>(true));
      verify(
        () => local.replaceFirstPage(october, filter, any(), nextCursor: 'abc'),
      ).called(1);
    });

    test('load more fetches from the stored cursor and appends', () async {
      // Arrange
      when(() => local.remoteKey(any(), any())).thenAnswer(
        (_) async => TransactionRemoteKeyRow(
          queryKey: 'k',
          nextCursor: 'abc',
          updatedAt: DateTime(2026),
        ),
      );
      when(() => remote.getTransactions(any()))
          .thenAnswer((_) async => _page(['t2']));

      // Act
      final result = await repository.loadMoreTransactions(october, filter);

      // Assert
      expect(result, const Right<Failure, bool>(false));
      final query =
          verify(() => remote.getTransactions(captureAny())).captured.single
              as TransactionQuery;
      expect(query.cursor, 'abc');
      verify(() => local.appendPage(october, filter, any(), nextCursor: null))
          .called(1);
    });

    test('load more past the last page makes no request', () async {
      // Arrange
      when(() => local.remoteKey(any(), any())).thenAnswer(
        (_) async =>
            TransactionRemoteKeyRow(queryKey: 'k', updatedAt: DateTime(2026)),
      );

      // Act
      final result = await repository.loadMoreTransactions(october, filter);

      // Assert
      expect(result, const Right<Failure, bool>(false));
      verifyNever(() => remote.getTransactions(any()));
    });
  });

  test('search sends the text, caches the results and pages on', () async {
    // Arrange
    when(() => remote.getTransactions(any()))
        .thenAnswer((_) async => _page(['t1'], nextCursor: 'next'));

    // Act
    final result = await repository.searchTransactions(
      'kopi',
      month: october,
      filter: const TransactionFilter(),
      cursor: 'abc',
    );

    // Assert
    final page = result.getRight().toNullable();
    expect(page?.items.single.id, 't1');
    expect(page?.nextCursor, 'next');
    final query =
        verify(() => remote.getTransactions(captureAny())).captured.single
            as TransactionQuery;
    expect(query.search, 'kopi');
    expect(query.cursor, 'abc');
    verify(() => local.upsertAll(any())).called(1);
  });

  group('refreshTransaction', () {
    test('caches the fetched transaction', () async {
      // Arrange
      when(() => remote.getTransaction('t1')).thenAnswer((_) async => _one());

      // Act
      final result = await repository.refreshTransaction('t1');

      // Assert
      final rows =
          verify(() => local.upsertAll(captureAny())).captured.single
              as List<TransactionRow>;
      expect(result, Right<Failure, Transaction>(rows.single.toEntity()));
    });

    test('drops one the server no longer has', () async {
      // Arrange
      when(() => remote.getTransaction('t1'))
          .thenThrow(const NotFoundException());

      // Act
      final result = await repository.refreshTransaction('t1');

      // Assert
      expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
      verify(() => local.deleteById('t1')).called(1);
    });
  });

  group('writes', () {
    final input = TransactionInput(
      type: TransactionType.expense,
      amount: 10000,
      walletId: 'w1',
      categoryId: 'c1',
      date: DateTime(2026, 10),
      note: 'Kopi',
      source: TransactionSource.quickAdd,
      receiptKey: 'receipts/k',
    );

    test('create sends the source and receipt and caches the result', () async {
      // Arrange
      when(() => remote.createTransaction(any()))
          .thenAnswer((_) async => _one());

      // Act
      final result = await repository.createTransaction(input);

      // Assert
      expect(result.getRight().toNullable()?.id, 't1');
      verify(
        () => remote.createTransaction(
          const TransactionRequest(
            type: 'EXPENSE',
            amount: 10000,
            walletId: 'w1',
            categoryId: 'c1',
            date: '2026-10-01',
            note: 'Kopi',
            source: 'QUICK_ADD',
            receiptKey: 'receipts/k',
          ),
        ),
      ).called(1);
      verify(() => local.upsertAll(any())).called(1);
    });

    test('update keeps the source and receipt', () async {
      // Arrange
      when(() => remote.updateTransaction(any(), any()))
          .thenAnswer((_) async => _one());

      // Act
      await repository.updateTransaction('t1', input);

      // Assert
      final request =
          verify(() => remote.updateTransaction('t1', captureAny()))
                  .captured
                  .single
              as TransactionRequest;
      expect(request.source, isNull);
      expect(request.receiptKey, isNull);
      expect(request.toJson().containsKey('source'), isFalse);
    });

    test(
      'a rejected write keeps its field errors and caches nothing',
      () async {
        // Arrange
        when(() => remote.createTransaction(any())).thenThrow(
          const ValidationException([
            FieldError(field: 'wallet_id', code: 'archived', message: 'x'),
          ]),
        );

        // Act
        final result = await repository.createTransaction(input);

        // Assert
        expect(
          result.getLeft().toNullable(),
          isA<ValidationFailure>().having(
            (f) => f.fieldErrors.single.code,
            'code',
            'archived',
          ),
        );
        verifyNever(() => local.upsertAll(any()));
      },
    );

    test('attachReceipt patches only the receipt key', () async {
      // Arrange
      when(() => remote.attachReceipt(any(), any()))
          .thenAnswer((_) async => _one());

      // Act
      await repository.attachReceipt('t1', 'receipts/k');

      // Assert
      verify(
        () => remote.attachReceipt(
          't1',
          const AttachReceiptRequest(receiptKey: 'receipts/k'),
        ),
      ).called(1);
    });

    test('restore caches the restored transaction', () async {
      // Arrange
      when(() => remote.restoreTransaction('t1'))
          .thenAnswer((_) async => _one());

      // Act
      final result = await repository.restoreTransaction('t1');

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => local.upsertAll(any())).called(1);
    });

    test('uploadReceipt gives the receipt key', () async {
      // Arrange
      when(() => remote.uploadReceipt(any(), filename: any(named: 'filename')))
          .thenAnswer(
            (_) async => ReceiptUploadResponse.fromJson(
              envelope({'receipt_key': 'receipts/k'}),
            ),
          );

      // Act
      final result = await repository.uploadReceipt(
        Uint8List(3),
        filename: 'r.webp',
      );

      // Assert
      expect(result, const Right<Failure, String>('receipts/k'));
    });
  });

  group('deleteTransaction', () {
    test(
      'deletes on the server and the cache, giving the cached copy',
      () async {
        // Arrange
        when(() => local.find('t1'))
            .thenAnswer((_) async => transactionRow(id: 't1'));
        when(() => remote.deleteTransaction('t1')).thenAnswer((_) async {});

        // Act
        final result = await repository.deleteTransaction('t1');

        // Assert
        expect(result.getRight().toNullable()?.id, 't1');
        verifyInOrder([
          () => remote.deleteTransaction('t1'),
          () => local.deleteById('t1'),
        ]);
      },
    );

    test('one already gone on the server still leaves the cache', () async {
      // Arrange
      when(() => local.find('t1')).thenAnswer((_) async => null);
      when(() => remote.deleteTransaction('t1'))
          .thenThrow(const NotFoundException());

      // Act
      final result = await repository.deleteTransaction('t1');

      // Assert
      expect(result, const Right<Failure, Object?>(null));
      verify(() => local.deleteById('t1')).called(1);
    });

    test('a network failure keeps the cached row', () async {
      // Arrange
      when(() => local.find('t1'))
          .thenAnswer((_) async => transactionRow(id: 't1'));
      when(() => remote.deleteTransaction('t1'))
          .thenThrow(const NetworkException());

      // Act
      final result = await repository.deleteTransaction('t1');

      // Assert
      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
      verifyNever(() => local.deleteById(any()));
    });
  });
}
