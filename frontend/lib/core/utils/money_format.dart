import 'package:intl/intl.dart';

final _rupiahDigits = NumberFormat.decimalPattern('id');

/// Formats whole rupiah the Indonesian way: `Rp 8.250.000`.
///
/// Negative amounts get a leading minus sign: `−Rp 35.000`.
String formatRupiah(int amount) {
  final digits = 'Rp ${_rupiahDigits.format(amount.abs())}';
  return amount < 0 ? '−$digits' : digits;
}

/// Formats [amount] with an explicit sign for a money direction:
/// `−Rp 35.000` when [negative], `+Rp 35.000` otherwise. The sign of
/// [amount] itself is ignored.
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
/// rounding up. Amounts under a thousand use [formatRupiah].
String formatRupiahCompact(int amount) {
  final abs = amount.abs();
  final unit = _compactUnits.where((u) => abs >= u.$1).firstOrNull;
  if (unit == null) return formatRupiah(amount);
  final (size, suffix) = unit;
  final whole = abs ~/ size;
  final tenth = (abs % size) ~/ (size ~/ 10);
  final number = '${_rupiahDigits.format(whole)}${tenth > 0 ? ',$tenth' : ''}';
  return '${amount < 0 ? '−' : ''}Rp $number $suffix';
}

final _nonDigits = RegExp(r'\D');

/// The whole rupiah typed in a money field, ignoring separators: 1250000
/// for `1.250.000`, 0 when nothing is typed.
int parseRupiahInput(String text) =>
    int.tryParse(text.replaceAll(_nonDigits, '')) ?? 0;

/// [amount] as a money field shows it: `1.250.000`.
String formatRupiahInput(int amount) => _rupiahDigits.format(amount);
