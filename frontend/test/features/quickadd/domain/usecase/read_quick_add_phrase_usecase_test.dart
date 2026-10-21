import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/domain/repository/quickadd_repository.dart';
import 'package:monai/features/quickadd/domain/usecase/read_quick_add_phrase_usecase.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements QuickaddRepository {}

final _context = ParseContext(
  wallets: [wallet(id: 'w-cash', isDefault: true)],
  categories: [
    category(id: 'food'),
    category(id: 'shopping', name: 'Shopping'),
    category(id: 'other', name: 'Other', isSystem: true),
  ],
  providers: const [],
  today: DateTime(2026, 10, 10),
);

void main() {
  late _MockRepository repository;
  late ReadQuickAddPhraseUseCase useCase;

  setUpAll(() => registerFallbackValue(TransactionType.expense));

  setUp(() {
    repository = _MockRepository();
    useCase = ReadQuickAddPhraseUseCase(repository);
  });

  Future<List<QuickAddDraft>> read(String text) async =>
      (await useCase(ReadQuickAddPhraseParams(text: text, context: _context)))
          .getOrElse((_) => const []);

  test('a category the user gave the same note wins over the guess', () async {
    // Arrange
    when(() => repository.categoryForNote('Kopi', TransactionType.expense))
        .thenAnswer((_) async => const Right('shopping'));

    // Act
    final drafts = await read('kopi 25rb');

    // Assert
    expect(drafts.single.categoryId, 'shopping');
    expect(
      drafts.single.confidence.category,
      ReadQuickAddPhraseUseCase.history,
    );
  });

  test('keeps the guess without history, or when the lookup fails', () async {
    // Arrange
    when(() => repository.categoryForNote(any(), any()))
        .thenAnswer((_) async => const Left(Failure.cache()));

    // Act
    final drafts = await read('kopi 25rb');

    // Assert
    expect(drafts.single.categoryId, 'food');
  });

  test('ignores a remembered category that is no longer visible', () async {
    // Arrange
    when(() => repository.categoryForNote(any(), any()))
        .thenAnswer((_) async => const Right('hidden'));

    // Act
    final drafts = await read('kopi 25rb');

    // Assert
    expect(drafts.single.categoryId, 'food');
  });
}
