import 'package:monai/features/quickadd/domain/parser/text_span.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

/// An amount found in lowercase quick-add text, with the characters it
/// covers.
class AmountMatch {
  const AmountMatch(this.amount, this.span, this.confidence);

  /// Rupiah.
  final int amount;
  final TextSpan span;
  final double confidence;

  /// Written as money (`35rb`, `35.000`, `goceng`) rather than a bare or odd
  /// number.
  bool get isClear => confidence >= AmountParser.plain;
}

/// Finds rupiah amounts such as `35rb`, `35.000`, `1,5jt` or `goceng`.
abstract final class AmountParser {
  static const explicit = 0.95;
  static const plain = 0.9;
  static const bareSmall = 0.4;
  static const oddDecimal = 0.3;

  // Group 1: digits split into groups of three (`2.500.000`); group 2: plain
  // or decimal (`1,5`).
  static final _number = RegExp(
    r'(?<![\w.,])(?:rp\.?\s*)?(?:(\d{1,3}(?:[.,]\d{3})+)|(\d+(?:[.,]\d+)?))'
    r'\s*(ribu|rebu|rb|k|jt|juta)?(?!\w)',
  );

  static final _slang = RegExp(
    r'(?<!\w)(gopek|seceng|ceceng|goceng|ceban|seribu|sejuta)(?!\w)',
  );

  static const _slangValues = {
    'gopek': 500,
    'seceng': 1000,
    'ceceng': 1000,
    'seribu': 1000,
    'goceng': 5000,
    'ceban': 10000,
    'sejuta': 1000000,
  };

  /// Every amount in [text], in order.
  static List<AmountMatch> findAll(String text) {
    final numbers = _number.allMatches(text).map(_numberMatch).nonNulls;
    final slang = _slang
        .allMatches(text)
        .map(
          (m) => AmountMatch(
            _slangValues[m.group(0)]!,
            TextSpan(m.start, m.end),
            plain,
          ),
        );
    return [...numbers, ...slang]
      ..sort((a, b) => a.span.start.compareTo(b.span.start));
  }

  static AmountMatch? _numberMatch(RegExpMatch match) {
    final grouped = match.group(1) ?? '';
    final plainDigits = match.group(2) ?? '';
    final suffix = match.group(3) ?? '';
    final multiplier = switch (suffix) {
      '' => 1,
      'jt' || 'juta' => 1000000,
      _ => 1000,
    };
    final (double value, double confidence) = switch (null) {
      _ when grouped.isNotEmpty => (
        double.parse(grouped.replaceAll(RegExp(r'\D'), '')),
        explicit,
      ),
      _ when suffix.isNotEmpty => (
        double.parse(plainDigits.replaceAll(',', '.')),
        explicit,
      ),
      _ when plainDigits.contains(RegExp('[.,]')) => (
        double.parse(plainDigits.replaceAll(',', '.')),
        oddDecimal,
      ),
      _ => _bare(double.parse(plainDigits)),
    };
    final amount = (value * multiplier).round();
    if (amount <= 0 || amount > TransactionInputValidator.amountMax) {
      return null;
    }
    return AmountMatch(amount, TextSpan(match.start, match.end), confidence);
  }

  static (double, double) _bare(double value) =>
      (value, value >= 1000 ? plain : bareSmall);
}
