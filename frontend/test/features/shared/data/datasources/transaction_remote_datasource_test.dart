import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/features/shared/data/datasources/endpoint/transaction_endpoint.dart';
import 'package:monai/features/shared/data/datasources/transaction_remote_datasource.dart';
import 'package:monai/features/shared/data/model/transaction_request.dart';

import '../../../../helpers/api_fixtures.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late TransactionRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = TransactionRemoteDataSourceImpl(dio: dio);
  });

  group('getTransactions', () {
    void stubGet() =>
        when(
          () => dio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => okResponse(
            TransactionEndpoint.transactions,
            envelope(
              [transactionJson()],
              meta: {'next_cursor': 'abc', 'has_more': true, 'limit': 20},
            ),
          ),
        );

    test('sends the month and limit, leaving unset filters out', () async {
      // Arrange
      stubGet();

      // Act
      final response = await dataSource.getTransactions(
        const TransactionQuery(month: '2026-10', limit: 20),
      );

      // Assert
      verify(
        () => dio.get<Map<String, dynamic>>(
          TransactionEndpoint.transactions,
          queryParameters: {'month': '2026-10', 'limit': 20},
        ),
      ).called(1);
      expect(response.data?.single.id, 't1');
      expect(response.meta?.nextCursor, 'abc');
      expect(response.meta?.hasMore, isTrue);
    });

    test('sends every filter, the search and the cursor', () async {
      // Arrange
      stubGet();

      // Act
      await dataSource.getTransactions(
        const TransactionQuery(
          month: '2026-10',
          limit: 20,
          walletId: 'w1',
          categoryId: 'c1',
          type: 'EXPENSE',
          search: 'kopi',
          cursor: 'abc',
        ),
      );

      // Assert
      verify(
        () => dio.get<Map<String, dynamic>>(
          TransactionEndpoint.transactions,
          queryParameters: {
            'month': '2026-10',
            'limit': 20,
            'wallet_id': 'w1',
            'category_id': 'c1',
            'type': 'EXPENSE',
            'q': 'kopi',
            'cursor': 'abc',
          },
        ),
      ).called(1);
    });

    test('a stale cursor fails as a bad request with its code', () async {
      // Arrange
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        errorResponse(TransactionEndpoint.transactions, 400, 'invalid_cursor'),
      );

      // Act
      final call = dataSource.getTransactions(
        const TransactionQuery(month: '2026-10', limit: 20, cursor: 'x'),
      );

      // Assert
      await expectLater(
        call,
        throwsA(
          isA<BadRequestException>().having(
            (e) => e.code,
            'code',
            'invalid_cursor',
          ),
        ),
      );
    });
  });

  test('updateTransaction sends nulls that clear fields', () async {
    // Arrange
    when(() => dio.patch<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async =>
              okResponse('/transactions/t1', envelope(transactionJson())),
        );

    // Act
    await dataSource.updateTransaction(
      't1',
      const TransactionRequest(
        type: 'EXPENSE',
        amount: 10000,
        walletId: 'w1',
        categoryId: 'c1',
        date: '2026-10-01',
      ),
    );

    // Assert
    final body = verify(
      () => dio.patch<Map<String, dynamic>>(
        TransactionEndpoint.transaction('t1'),
        data: captureAny(named: 'data'),
      ),
    ).captured.single;
    expect(body, {
      'type': 'EXPENSE',
      'amount': 10000,
      'wallet_id': 'w1',
      'to_wallet_id': null,
      'category_id': 'c1',
      'date': '2026-10-01',
      'note': null,
      'merchant': null,
    });
  });

  test('restoreTransaction posts to the restore path', () async {
    // Arrange
    when(() => dio.post<Map<String, dynamic>>(any())).thenAnswer(
      (_) async =>
          okResponse('/transactions/t1/restore', envelope(transactionJson())),
    );

    // Act
    final response = await dataSource.restoreTransaction('t1');

    // Assert
    verify(
      () => dio.post<Map<String, dynamic>>(TransactionEndpoint.restore('t1')),
    ).called(1);
    expect(response.data?.id, 't1');
  });

  test('uploadReceipt sends the photo as the multipart file', () async {
    // Arrange
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async => okResponse(
            TransactionEndpoint.receipt,
            envelope({'receipt_key': 'receipts/u1/abc.webp'}),
          ),
        );

    // Act
    final response = await dataSource.uploadReceipt(
      Uint8List.fromList([1, 2, 3]),
      filename: 'receipt.webp',
    );

    // Assert
    final form =
        verify(
              () => dio.post<Map<String, dynamic>>(
                TransactionEndpoint.receipt,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as FormData;
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.filename, 'receipt.webp');
    expect(form.files.single.value.length, 3);
    expect(response.data?.receiptKey, 'receipts/u1/abc.webp');
  });
}
