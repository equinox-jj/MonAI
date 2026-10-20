import 'package:monai/features/quickadd/domain/parser/amount_parser.dart';

/// Splits a phrase with several purchases ("kopi 25rb sama parkir 5rb kmrn")
/// into one part per amount. A part without an amount ("kmrn") stays with
/// the part before it, so a phrase with one amount is never split. Without
/// a separator, a part with several clear amounts ("makan 35rb bensin 20rb")
/// is cut after each one.
abstract final class PhraseSplitter {
  static final _separator = RegExp(
    r'\s+(?:sama|dan|terus|trus|plus|and|&)\s+|\s*[;+]\s*|,\s+|\n+',
  );

  static List<String> split(
    String text,
    List<AmountMatch> Function(String) amountsIn,
  ) {
    bool hasAmount(String part) => amountsIn(part).isNotEmpty;
    final parts = text
        .split(_separator)
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    final merged = parts.where(hasAmount).length < 2
        ? [text.trim()]
        : _merge(parts, hasAmount);
    return [
      for (final part in merged)
        ..._cutAfterClearAmounts(part, amountsIn(part)),
    ];
  }

  static List<String> _merge(
    List<String> parts,
    bool Function(String) hasAmount,
  ) {
    final merged = <String>[];
    for (final part in parts) {
      if (hasAmount(part) || merged.isEmpty) {
        merged.add(part);
      } else {
        merged.last = '${merged.last} $part';
      }
    }
    // A leading part without an amount ("kemarin, kopi 25rb, roti 10rb")
    // joins the next one.
    if (!hasAmount(merged.first) && merged.length > 1) {
      merged[1] = '${merged.first} ${merged[1]}';
      merged.removeAt(0);
    }
    return merged;
  }

  // Unclear numbers ("beli 2 kopi 50rb") never cut; the words after the
  // last amount stay with it.
  static List<String> _cutAfterClearAmounts(
    String part,
    List<AmountMatch> amounts,
  ) {
    final clear = amounts.where((a) => a.isClear).toList();
    if (clear.length < 2) return [part];
    final cuts = clear.sublist(0, clear.length - 1).map((a) => a.span.end);
    final starts = [0, ...cuts];
    final ends = [...cuts, part.length];
    return [
      for (var i = 0; i < starts.length; i++)
        part.substring(starts[i], ends[i]).trim(),
    ];
  }
}
