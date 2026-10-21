// Uppercase only: FTS treats lowercase "or"/"and" as plain words.
const _ftsOperators = {'AND', 'OR', 'NOT', 'NEAR'};

final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

/// Prefix-matches every word, so "kopi ken" finds "Kopi Kenangan". Each word
/// is quoted, so quotes, `*`, `-` and parentheses are never read as query
/// syntax. Null when nothing searchable is left.
String? toFtsMatchQuery(String raw) {
  final words = raw
      .split(_nonWord)
      .where((word) => word.isNotEmpty && !_ftsOperators.contains(word))
      .toList();
  if (words.isEmpty) return null;
  return words.map((word) => '"$word"*').join(' ');
}
