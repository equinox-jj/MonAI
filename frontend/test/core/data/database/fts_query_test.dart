import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/fts_query.dart';

void main() {
  test('prefix-matches every word', () {
    // Arrange
    const raw = 'kopi ken';

    // Act
    final result = toFtsMatchQuery(raw);

    // Assert
    expect(result, '"kopi"* "ken"*');
  });

  test('drops punctuation and query syntax', () {
    // Arrange
    const raw = '"kopi" -(susu)* gula-aren';

    // Act
    final result = toFtsMatchQuery(raw);

    // Assert
    expect(result, '"kopi"* "susu"* "gula"* "aren"*');
  });

  test('drops uppercase operators but keeps lowercase words', () {
    // Arrange
    const raw = 'kopi OR teh and NEAR susu';

    // Act
    final result = toFtsMatchQuery(raw);

    // Assert
    expect(result, '"kopi"* "teh"* "and"* "susu"*');
  });

  test('keeps letters beyond ASCII', () {
    // Arrange
    const raw = 'café';

    // Act
    final result = toFtsMatchQuery(raw);

    // Assert
    expect(result, '"café"*');
  });

  test('returns null when nothing searchable is left', () {
    // Arrange
    const raw = '  -*() AND ';

    // Act
    final result = toFtsMatchQuery(raw);

    // Assert
    expect(result, isNull);
  });
}
