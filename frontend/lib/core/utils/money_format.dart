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
