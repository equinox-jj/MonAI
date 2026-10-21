// Uppercase only: FTS treats lowercase "or"/"and" as plain words.
const _ftsOperators = {'AND', 'OR', 'NOT', 'NEAR'};

final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

/// Turns free text into an FTS5 `MATCH` expression that prefix-matches every
/// word, so "kopi ken" finds "Kopi Kenangan". Punctuation is dropped (the
/// unicode61 tokenizer splits on it anyway) and each word is quoted, which
/// keeps quotes, `*`, `-` and parentheses from being read as query syntax.
///
/// Returns null when nothing searchable is left.
String? toFtsMatchQuery(String raw) {
  final words = raw
      .split(_nonWord)
      .where((word) => word.isNotEmpty && !_ftsOperators.contains(word))
      .toList();
  if (words.isEmpty) return null;
  return words.map((word) => '"$word"*').join(' ');
}
