import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/quickadd/domain/entity/ai_draft.dart';
import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/domain/repository/quickadd_repository.dart';
import 'package:monai/features/quickadd/domain/usecase/complete_drafts_with_ai_usecase.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements QuickaddRepository {}

class _MockWatchUser extends Mock implements WatchUserUseCase {}

final _today = DateTime(2026, 10, 10);
final _context = ParseContext(
  wallets: [wallet(id: 'w-cash', isDefault: true)],
  categories: [category(id: 'food')],
  providers: const [],
  today: _today,
);

QuickAddDraft _draft({
  int? amount,
  String? categoryId,
  double amountConfidence = 0.95,
  double categoryConfidence = 0.85,
}) => QuickAddDraft(
  type: TransactionType.expense,
  date: _today,
  amount: amount,
  walletId: 'w-cash',
  categoryId: categoryId,
  note: 'Arisan',
  confidence: DraftConfidence(
    type: 0.9,
    amount: amountConfidence,
    wallet: 0.5,
    category: categoryConfidence,
    date: 0.9,
  ),
);

void main() {
  late _MockRepository repository;
  late _MockWatchUser watchUser;
  late CompleteDraftsWithAiUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    repository = _MockRepository();
    watchUser = _MockWatchUser();
    useCase = CompleteDraftsWithAiUseCase(
      repository: repository,
      watchUser: watchUser,
      timeout: const Duration(milliseconds: 50),
      now: () => DateTime(2026, 10, 10, 12),
    );
    when(() => watchUser(any()))
        .thenAnswer((_) => Stream.value(Right<Failure, User?>(user())));
  });

  void stubAi(Future<Either<Failure, List<AiDraft>>> Function() answer) => when(
    () => repository.parse(
      any(),
      today: any(named: 'today'),
      timezone: any(named: 'timezone'),
    ),
  ).thenAnswer((_) => answer());

  test('keeps sure local drafts without calling the AI', () async {
    // Arrange
    final local = [_draft(amount: 35000, categoryId: 'food')];

    // Act
    final result = await useCase(
      CompleteDraftsParams(text: 'x', local: local, context: _context),
    );

    // Assert
    expect(
      result.getOrElse((_) => throw StateError('')),
      QuickAddReading(drafts: local, engine: DraftEngine.local),
    );
    verifyNever(
      () => repository.parse(
        any(),
        today: any(named: 'today'),
        timezone: any(named: 'timezone'),
      ),
    );
  });

  test(
    "asks the AI with the user's timezone and fills its gaps locally",
    () async {
      // Arrange
      final local = [_draft(categoryId: 'food', amountConfidence: 0)];
      stubAi(
        () async => const Right([
          AiDraft(amount: 50000, confidence: DraftConfidence(amount: 0.9)),
        ]),
      );

      // Act
      final result = await useCase(
        CompleteDraftsParams(
          text: '  arisan 50 ribu  ',
          local: local,
          context: _context,
        ),
      );

      // Assert
      final reading = result.getOrElse((_) => throw StateError(''));
      expect(reading.engine, DraftEngine.ai);
      final draft = reading.drafts.single;
      expect(draft.amount, 50000);
      expect(draft.confidence.amount, 0.9);
      expect(draft.categoryId, 'food');
      expect(draft.confidence.category, 0.85);
      expect(draft.walletId, 'w-cash');
      expect(draft.note, 'Arisan');
      verify(
        () => repository.parse(
          'arisan 50 ribu',
          today: _today,
          timezone: 'Asia/Jakarta',
        ),
      ).called(1);
    },
  );

  test('falls back to the local drafts when rate-limited', () async {
    // Arrange
    final local = [_draft(categoryId: 'food', amountConfidence: 0)];
    stubAi(() async => const Left(Failure.tooManyRequests()));

    // Act
    final result = await useCase(
      CompleteDraftsParams(text: 'x', local: local, context: _context),
    );

    // Assert
    expect(
      result.getOrElse((_) => throw StateError('')),
      QuickAddReading(
        drafts: local,
        engine: DraftEngine.fallback,
        aiFailure: QuickAddAiFailure.rateLimited,
      ),
    );
  });

  test('falls back as offline when the AI takes too long', () async {
    // Arrange
    final local = [_draft(categoryId: 'food', amountConfidence: 0)];
    stubAi(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      return const Right([]);
    });

    // Act
    final result = await useCase(
      CompleteDraftsParams(text: 'x', local: local, context: _context),
    );

    // Assert
    final reading = result.getOrElse((_) => throw StateError(''));
    expect(reading.engine, DraftEngine.fallback);
    expect(reading.aiFailure, QuickAddAiFailure.offline);
  });

  test('falls back when the AI reads nothing', () async {
    // Arrange
    final local = [_draft(categoryId: 'food', amountConfidence: 0)];
    stubAi(() async => const Right([]));

    // Act
    final result = await useCase(
      CompleteDraftsParams(text: 'x', local: local, context: _context),
    );

    // Assert
    final reading = result.getOrElse((_) => throw StateError(''));
    expect(reading.engine, DraftEngine.fallback);
    expect(reading.drafts, local);
  });
}
