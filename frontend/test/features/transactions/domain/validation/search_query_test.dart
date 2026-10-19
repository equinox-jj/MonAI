import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/transactions/domain/validation/search_query.dart';

void main() {
  test('trims the text', () {
    // Arrange
    const raw = '  kopi  ';

    // Act
    final query = raw.normalizedSearch;

    // Assert
    expect(query, 'kopi');
  });

  test('cuts the text to the server maximum', () {
    // Arrange
    final raw = 'é' * 150;

    // Act
    final query = raw.normalizedSearch;

    // Assert
    expect(query.runes.length, SearchQuery.maxLength);
  });

  test('blank text becomes empty', () {
    // Arrange
    const raw = '   ';

    // Act
    final query = raw.normalizedSearch;

    // Assert
    expect(query, isEmpty);
  });
}
