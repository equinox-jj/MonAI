import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/transactions/domain/repository/search_history_repository.dart';
import 'package:monai/features/transactions/domain/usecase/recent_searches_usecase.dart';

class _MockRepository extends Mock implements SearchHistoryRepository {}

void main() {
  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
    when(() => repository.recentSearches())
        .thenAnswer((_) async => const Right(['a']));
    when(() => repository.addRecentSearch(any()))
        .thenAnswer((_) async => const Right(['kopi', 'a']));
  });

  test('get forwards to the repository', () async {
    // Arrange
    // (the repository stubbed in setUp)

    // Act
    final result = await GetRecentSearchesUseCase(repository)(const NoParams());

    // Assert
    expect(result.getRight().toNullable(), ['a']);
  });

  test('add saves the cleaned-up text', () async {
    // Arrange
    // (the repository stubbed in setUp)

    // Act
    final result = await AddRecentSearchUseCase(repository)('  kopi ');

    // Assert
    expect(result.getRight().toNullable(), ['kopi', 'a']);
    verify(() => repository.addRecentSearch('kopi')).called(1);
  });

  test('add ignores blank text and gives the list unchanged', () async {
    // Arrange
    // (the repository stubbed in setUp)

    // Act
    final result = await AddRecentSearchUseCase(repository)('   ');

    // Assert
    expect(result.getRight().toNullable(), ['a']);
    verifyNever(() => repository.addRecentSearch(any()));
  });
}
