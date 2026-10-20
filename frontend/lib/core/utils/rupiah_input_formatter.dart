import 'package:flutter/services.dart';
import 'package:monai/core/utils/money_format.dart';

/// Keeps a money field to digits grouped the Indonesian way as the user
/// types: `1250000` shows as `1.250.000`, with the cursor at the end.
class RupiahInputFormatter extends TextInputFormatter {
  /// [maxDigits] caps the amount; extra digits are dropped.
  const RupiahInputFormatter({this.maxDigits = 15});

  final int maxDigits;

  static final _nonDigits = RegExp(r'\D');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(_nonDigits, '');
    if (digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    final text = digits.isEmpty
        ? ''
        : formatRupiahInput(parseRupiahInput(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
