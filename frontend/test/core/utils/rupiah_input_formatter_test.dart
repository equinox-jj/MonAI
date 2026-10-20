import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/rupiah_input_formatter.dart';

TextEditingValue _type(String text) => const RupiahInputFormatter()
    .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text));

void main() {
  test('groups digits with dots and keeps the cursor at the end', () {
    // Act
    final value = _type('1250000');

    // Assert
    expect(value.text, '1.250.000');
    expect(value.selection.baseOffset, value.text.length);
  });

  test('drops anything but digits, and leading zeros', () {
    // Act
    final value = _type('0Rp 1.2a5');

    // Assert
    expect(value.text, '125');
  });

  test('stops at the digit limit', () {
    // Act
    final value = _type('12345678901234567');

    // Assert
    expect(parseRupiahInput(value.text), 123456789012345);
  });

  test('parseRupiahInput reads an empty field as 0', () {
    // Act
    final amount = parseRupiahInput('');

    // Assert
    expect(amount, 0);
  });
}
