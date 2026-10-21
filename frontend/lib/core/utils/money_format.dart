import 'package:intl/intl.dart';

final _rupiahDigits = NumberFormat.decimalPattern('id');

String formatRupiah(int amount) {
  final digits = 'Rp ${_rupiahDigits.format(amount.abs())}';
  return amount < 0 ? '−$digits' : digits;
}

/// `−Rp 35.000` when [negative], else `+Rp 35.000`; the sign of [amount] is
/// ignored.
String formatRupiahSigned(int amount, {required bool negative}) =>
    '${negative ? '−' : '+'}${formatRupiah(amount.abs())}';

const _compactUnits = [
  (1000000000000, 'T'),
  (1000000000, 'M'),
  (1000000, 'jt'),
  (1000, 'rb'),
];

/// Formats whole rupiah in short form: `Rp 35 rb`, `Rp 2,4 jt`, `Rp 2 M`.
///
/// Keeps one decimal, truncated, so 999.999 reads `Rp 999,9 rb` rather than
/// rounding up. Amounts under a thousand use [formatRupiah]. Without
/// [symbol], the `Rp` is left out: `2,5 jt`.
String formatRupiahCompact(int amount, {bool symbol = true}) {
  final abs = amount.abs();
  final unit = _compactUnits.where((u) => abs >= u.$1).firstOrNull;
  final sign = amount < 0 ? '−' : '';
  final rp = symbol ? 'Rp ' : '';
  if (unit == null) return '$sign$rp${_rupiahDigits.format(abs)}';
  final (size, suffix) = unit;
  final whole = abs ~/ size;
  final tenth = (abs % size) ~/ (size ~/ 10);
  final number = '${_rupiahDigits.format(whole)}${tenth > 0 ? ',$tenth' : ''}';
  return '$sign$rp$number $suffix';
}

final _nonDigits = RegExp(r'\D');

int parseRupiahInput(String text) =>
    int.tryParse(text.replaceAll(_nonDigits, '')) ?? 0;

String formatRupiahInput(int amount) => _rupiahDigits.format(amount);
