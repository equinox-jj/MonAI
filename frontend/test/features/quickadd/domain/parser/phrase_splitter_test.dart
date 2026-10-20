import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/quickadd/domain/parser/amount_parser.dart';
import 'package:monai/features/quickadd/domain/parser/phrase_splitter.dart';

List<String> _split(String text) =>
    PhraseSplitter.split(text, AmountParser.findAll);

void main() {
  group('PhraseSplitter', () {
    test('one part per amount', () {
      // Act
      final withSama = _split('kopi 25rb sama parkir 5rb kmrn');
      final withComma = _split('kopi 25rb, roti 10rb');

      // Assert
      expect(withSama, ['kopi 25rb', 'parkir 5rb kmrn']);
      expect(withComma, ['kopi 25rb', 'roti 10rb']);
    });

    test('a part without an amount joins its neighbour', () {
      // Act
      final trailing = _split('kopi 25rb, kemarin; roti 10rb');
      final leading = _split('kemarin, kopi 25rb, roti 10rb');

      // Assert
      expect(trailing, ['kopi 25rb kemarin', 'roti 10rb']);
      expect(leading, ['kemarin kopi 25rb', 'roti 10rb']);
    });

    test('a phrase with one amount is not split', () {
      // Act
      final withDan = _split('nasi dan ayam 30rb');
      final decimal = _split('hp 1,5jt');

      // Assert
      expect(withDan, ['nasi dan ayam 30rb']);
      expect(decimal, ['hp 1,5jt']);
    });

    test('clear amounts without a separator each start a new part', () {
      // Act
      final many = _split('makan siang 35rb pakai gopay 15rb 20rb 40 rb');
      final two = _split('kopi 25rb roti 10rb kemarin');

      // Assert
      expect(many, ['makan siang 35rb', 'pakai gopay 15rb', '20rb', '40 rb']);
      expect(two, ['kopi 25rb', 'roti 10rb kemarin']);
    });

    test('an unclear number next to a clear amount does not split', () {
      // Act
      final parts = _split('beli 2 kopi 50rb');

      // Assert
      expect(parts, ['beli 2 kopi 50rb']);
    });
  });
}
