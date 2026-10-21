import 'package:flutter/services.dart';
import 'package:monai/core/utils/money_format.dart';

class RupiahInputFormatter extends TextInputFormatter {
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
