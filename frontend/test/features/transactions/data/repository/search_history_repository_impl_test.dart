import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/transactions/data/datasources/search_history_local_datasource.dart';
import 'package:monai/features/transactions/data/repository/search_history_repository_impl.dart';

class _MockLocal extends Mock implements SearchHistoryLocalDataSource {}

void main() {
  late _MockLocal local;
  late SearchHistoryRepositoryImpl repository;

  setUp(() {
    local = _MockLocal();
    repository = SearchHistoryRepositoryImpl(local: local);
  });

  test('adding a search saves it and gives the updated list', () async {
    // Arrange
    when(() => local.addRecentSearch('kopi')).thenAnswer((_) async {});
    when(() => local.recentSearches()).thenAnswer((_) async => ['kopi', 'a']);

    // Act
    final result = await repository.addRecentSearch('kopi');

    // Assert
    expect(result.getRight().toNullable(), ['kopi', 'a']);
    verify(() => local.addRecentSearch('kopi')).called(1);
  });

  test('a storage error becomes a cache failure', () async {
    // Arrange
    when(() => local.recentSearches())
        .thenThrow(const CacheException(message: 'boom'));

    // Act
    final result = await repository.recentSearches();

    // Assert
    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });
}
