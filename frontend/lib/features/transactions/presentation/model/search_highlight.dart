import 'package:flutter/painting.dart';

final _word = RegExp(r'[\p{L}\p{N}]+', unicode: true);

extension SearchHighlight on String {
  bool matchesSearch(String query) {
    final text = toLowerCase();
    return _word
        .allMatches(query)
        .any((word) => text.contains(word[0]!.toLowerCase()));
  }

  /// Marks every case-insensitive occurrence of each word of [query];
  /// overlapping matches keep the earlier one.
  TextSpan highlighted(String? query, TextStyle mark) {
    if (query == null || query.trim().isEmpty) return TextSpan(text: this);
    final matches = [
      for (final word in _word.allMatches(query))
        ...RegExp(
          RegExp.escape(word[0]!),
          caseSensitive: false,
          unicode: true,
        ).allMatches(this),
    ]..sort((a, b) => a.start.compareTo(b.start));
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start < cursor) continue;
      if (match.start > cursor) {
        spans.add(TextSpan(text: substring(cursor, match.start)));
      }
      spans.add(TextSpan(text: match[0], style: mark));
      cursor = match.end;
    }
    if (cursor < length) spans.add(TextSpan(text: substring(cursor)));
    return TextSpan(children: spans);
  }
}
