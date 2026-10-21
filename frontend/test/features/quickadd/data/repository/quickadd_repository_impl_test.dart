import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/data/datasources/quickadd_local_datasource.dart';
import 'package:monai/features/quickadd/data/datasources/quickadd_remote_datasource.dart';
import 'package:monai/features/quickadd/data/model/parse_transaction_request.dart';
import 'package:monai/features/quickadd/data/model/parse_transaction_response.dart';
import 'package:monai/features/quickadd/data/repository/quickadd_repository_impl.dart';
import 'package:monai/features/quickadd/domain/entity/ai_draft.dart';
import 'package:monai/features/shared/data/model/draft_confidence_data.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';

class _MockRemote extends Mock implements QuickaddRemoteDataSource {}

class _MockLocal extends Mock implements QuickaddLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late QuickaddRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const ParseTransactionRequest(text: '', today: '', timezone: ''),
    );
    registerFallbackValue(TransactionType.expense);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = QuickaddRepositoryImpl(remote: remote, local: local);
  });

  group('parse', () {
    test('sends the phrase with the date and timezone', () async {
      // Arrange
      when(() => remote.parseTransaction(any())).thenAnswer(
        (_) async => const ParseTransactionResponse(
          data: ParseTransactionData(drafts: []),
        ),
      );

      // Act
      await repository.parse(
        'kopi 25rb',
        today: DateTime(2026, 10, 10),
        timezone: 'Asia/Jakarta',
      );

      // Assert
      verify(
        () => remote.parseTransaction(
          const ParseTransactionRequest(
            text: 'kopi 25rb',
            today: '2026-10-10',
            timezone: 'Asia/Jakarta',
          ),
        ),
      ).called(1);
    });

    test('maps the drafts, dropping values the app cannot use', () async {
      // Arrange
      when(() => remote.parseTransaction(any())).thenAnswer(
        (_) async => const ParseTransactionResponse(
          data: ParseTransactionData(
            drafts: [
              TransactionDraftData(
                type: 'EXPENSE',
                amount: 25000,
                walletId: 'w1',
                categoryId: 'c1',
                date: '2026-10-09',
                note: ' Kopi ',
                confidence: DraftConfidenceData(amount: 0.9, category: 0.8),
              ),
              TransactionDraftData(type: 'BOGUS', amount: -5, date: '9/10'),
            ],
          ),
        ),
      );

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 10),
        timezone: 'UTC',
      );

      // Assert
      expect(result.getOrElse((_) => const []), [
        AiDraft(
          type: TransactionType.expense,
          amount: 25000,
          walletId: 'w1',
          categoryId: 'c1',
          date: DateTime(2026, 10, 9),
          note: 'Kopi',
          confidence: const DraftConfidence(amount: 0.9, category: 0.8),
        ),
        const AiDraft(),
      ]);
    });

    test('returns Left(TooManyRequestsFailure) when rate-limited', () async {
      // Arrange
      when(() => remote.parseTransaction(any()))
          .thenThrow(const TooManyRequestsException(message: 'slow down'));

      // Act
      final result = await repository.parse(
        'x',
        today: DateTime(2026, 10, 10),
        timezone: 'UTC',
      );

      // Assert
      expect(result.getLeft().toNullable(), isA<TooManyRequestsFailure>());
    });
  });

  group('categoryForNote', () {
    test('looks the note up trimmed and lowercase', () async {
      // Arrange
      when(() => local.categoryForText(any(), any()))
          .thenAnswer((_) async => 'food');

      // Act
      final result = await repository.categoryForNote(
        '  Kopi ',
        TransactionType.expense,
      );

      // Assert
      expect(result, const Right<Failure, String?>('food'));
      verify(() => local.categoryForText('kopi', TransactionType.expense))
          .called(1);
    });
  });
}
