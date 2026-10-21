import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/data/services/image_compressor_service.dart';
import 'package:monai/core/data/services/receipt_scanner_service.dart';
import 'package:monai/features/receipt/data/datasources/receipt_remote_datasource.dart';
import 'package:monai/features/receipt/data/model/parse_receipt_request.dart';
import 'package:monai/features/receipt/data/model/parse_receipt_response.dart';
import 'package:monai/features/receipt/data/repository/receipt_repository_impl.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';

class _MockScanner extends Mock implements ReceiptScannerService {}

class _MockCompressor extends Mock implements ImageCompressorService {}

class _MockRemote extends Mock implements ReceiptRemoteDataSource {}

void main() {
  late _MockScanner scanner;
  late _MockCompressor compressor;
  late _MockRemote remote;
  late ReceiptRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const ParseReceiptRequest(ocrText: '', today: '', timezone: ''),
    );
  });

  setUp(() {
    scanner = _MockScanner();
    compressor = _MockCompressor();
    remote = _MockRemote();
    repository = ReceiptRepositoryImpl(
      scanner: scanner,
      compressor: compressor,
      remote: remote,
    );
  });

  group('readText', () {
    test('returns Right with the text the scanner read', () async {
      // Arrange
      when(() => scanner.readText('/tmp/receipt.jpg'))
          .thenAnswer((_) async => 'TOTAL 25.000');

      // Act
      final result = await repository.readText('/tmp/receipt.jpg');

      // Assert
      expect(result, const Right<Failure, String?>('TOTAL 25.000'));
    });

    test(
      'returns Left(UnknownFailure) with the code when reading fails',
      () async {
        // Arrange
        when(() => scanner.readText(any())).thenThrow(
          const UnknownException(message: 'boom', code: 'recognition_failed'),
        );

        // Act
        final result = await repository.readText('/tmp/receipt.jpg');

        // Assert
        expect(
          result,
          const Left<Failure, String?>(
            Failure.unknown(message: 'boom', code: 'recognition_failed'),
          ),
        );
      },
    );
  });

  group('compressPhoto', () {
    test('returns the compressed photo', () async {
      // Arrange
      final bytes = Uint8List(10);
      when(() => compressor.compressForUpload('/tmp/receipt.jpg'))
          .thenAnswer((_) async => bytes);

      // Act
      final result = await repository.compressPhoto('/tmp/receipt.jpg');

      // Assert
      expect(result, Right<Failure, Uint8List>(bytes));
    });

    test('returns Left with the code when the photo is too large', () async {
      // Arrange
      when(() => compressor.compressForUpload(any())).thenThrow(
        const UnknownException(message: 'big', code: 'photo_too_large'),
      );

      // Act
      final result = await repository.compressPhoto('/tmp/receipt.jpg');

      // Assert
      expect(
        result,
        const Left<Failure, Uint8List>(
          Failure.unknown(message: 'big', code: 'photo_too_large'),
        ),
      );
    });
  });

  group('parse', () {
    test('sends the text, the date and the timezone', () async {
      // Arrange
      when(() => remote.parseReceipt(any())).thenAnswer(
        (_) async => const ParseReceiptResponse(
          data: ParseReceiptData(draft: ReceiptDraftData()),
        ),
      );

      // Act
      await repository.parse(
        'TOTAL 187.500',
        today: DateTime(2026, 10, 9),
        timezone: 'Asia/Jakarta',
      );

      // Assert
      verify(
        () => remote.parseReceipt(
          const ParseReceiptRequest(
            ocrText: 'TOTAL 187.500',
            today: '2026-10-09',
            timezone: 'Asia/Jakarta',
          ),
        ),
      ).called(1);
    });

    test('returns the draft with its items', () async {
      // Arrange
      when(() => remote.parseReceipt(any())).thenAnswer(
        (_) async => const ParseReceiptResponse(
          data: ParseReceiptData(
            draft: ReceiptDraftData(
              type: 'EXPENSE',
              amount: 187500,
              walletId: 'w1',
              categoryId: 'c1',
              date: '2026-10-09',
              note: 'Belanja',
              merchant: 'Toko Sumber Rejeki',
              confidence: DraftConfidenceData(
                type: 0.9,
                amount: 0.95,
                wallet: 0.2,
                category: 0.8,
                date: 0.4,
              ),
              items: [
                ReceiptItemData(name: 'Beras 5 kg', quantity: 1, amount: 74000),
              ],
            ),
          ),
        ),
      );

      // Act
      final result = await repository.parse(
        'TOTAL 187.500',
        today: DateTime(2026, 10, 9),
        timezone: 'Asia/Jakarta',
      );

      // Assert
      expect(
        result,
        Right<Failure, ReceiptDraft>(
          ReceiptDraft(
            type: TransactionType.expense,
            amount: 187500,
            walletId: 'w1',
            categoryId: 'c1',
            date: DateTime(2026, 10, 9),
            note: 'Belanja',
            merchant: 'Toko Sumber Rejeki',
            confidence: const DraftConfidence(
              type: 0.9,
              amount: 0.95,
              wallet: 0.2,
              category: 0.8,
              date: 0.4,
            ),
            items: const [
              ReceiptItem(name: 'Beras 5 kg', quantity: 1, amount: 74000),
            ],
          ),
        ),
      );
    });

    test('a draft with nothing filled is an empty draft', () async {
      // Arrange
      when(() => remote.parseReceipt(any())).thenAnswer(
        (_) async => const ParseReceiptResponse(
          data: ParseReceiptData(draft: ReceiptDraftData()),
        ),
      );

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 9),
        timezone: 'UTC',
      );

      // Assert
      expect(result, const Right<Failure, ReceiptDraft>(ReceiptDraft.empty));
    });

    test('drops an unknown type or date and items without a name', () async {
      // Arrange
      when(() => remote.parseReceipt(any())).thenAnswer(
        (_) async => const ParseReceiptResponse(
          data: ParseReceiptData(
            draft: ReceiptDraftData(
              type: 'REFUND',
              date: 'yesterday',
              items: [
                ReceiptItemData(amount: 5000),
                ReceiptItemData(name: 'Parkir', amount: 5000),
              ],
            ),
          ),
        ),
      );

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 9),
        timezone: 'UTC',
      );

      // Assert
      expect(
        result,
        const Right<Failure, ReceiptDraft>(
          ReceiptDraft(items: [ReceiptItem(name: 'Parkir', amount: 5000)]),
        ),
      );
    });

    test('a transfer draft becomes no type: a receipt is never one', () async {
      // Arrange
      when(() => remote.parseReceipt(any())).thenAnswer(
        (_) async => const ParseReceiptResponse(
          data: ParseReceiptData(draft: ReceiptDraftData(type: 'TRANSFER')),
        ),
      );

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 9),
        timezone: 'UTC',
      );

      // Assert
      expect(result, const Right<Failure, ReceiptDraft>(ReceiptDraft.empty));
    });

    test('a response without a draft fails as malformed', () async {
      // Arrange
      when(() => remote.parseReceipt(any()))
          .thenAnswer((_) async => const ParseReceiptResponse());

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 9),
        timezone: 'UTC',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('passes the rate limit through', () async {
      // Arrange
      when(() => remote.parseReceipt(any()))
          .thenThrow(const TooManyRequestsException(code: 'rate_limited'));

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 9),
        timezone: 'UTC',
      );

      // Assert
      expect(
        result,
        const Left<Failure, ReceiptDraft>(
          Failure.tooManyRequests(code: 'rate_limited'),
        ),
      );
    });

    test('passes the AI being down through', () async {
      // Arrange
      when(() => remote.parseReceipt(any()))
          .thenThrow(const ServiceUnavailableException(code: 'ai_unavailable'));

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 9),
        timezone: 'UTC',
      );

      // Assert
      expect(
        result,
        const Left<Failure, ReceiptDraft>(
          Failure.serviceUnavailable(code: 'ai_unavailable'),
        ),
      );
    });
  });
}
