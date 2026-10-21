import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/transactions/presentation/model/search_highlight.dart';

void main() {
  const mark = TextStyle(fontWeight: FontWeight.w600);

  List<String> marked(TextSpan span) => [
    for (final child in span.children ?? const <InlineSpan>[])
      if (child is TextSpan && child.style == mark) child.text!,
  ];

  test(
    'keeps the whole text and marks every match of every word, ignoring case',
    () {
      // Arrange
      const text = 'Kopi susu dan kopi pagi';

      // Act
      final span = text.highlighted('kopi pagi', mark);

      // Assert
      expect(span.toPlainText(), text);
      expect(marked(span), ['Kopi', 'kopi', 'pagi']);
    },
  );

  test('no query or no match leaves the text plain', () {
    // Act
    final noQuery = 'Kopi susu'.highlighted(null, mark);
    final noMatch = 'Kopi susu'.highlighted('teh', mark);

    // Assert
    expect(marked(noQuery), isEmpty);
    expect(marked(noMatch), isEmpty);
    expect(noMatch.toPlainText(), 'Kopi susu');
  });

  test('matchesSearch looks for any word of the query', () {
    // Act
    final hit = 'Warung Kopi Pak Min'.matchesSearch('pagi kopi');
    final miss = 'Warung Kopi'.matchesSearch('teh');

    // Assert
    expect(hit, isTrue);
    expect(miss, isFalse);
  });
}
