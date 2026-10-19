// The one place search text is cleaned up, matching the server's `q` rules.

/// Search text cleanup applied by the search use cases.
extension SearchQuery on String {
  /// The server's maximum query length, in characters.
  static const maxLength = 100;

  /// Trimmed and cut to [maxLength]; empty means nothing to search.
  String get normalizedSearch {
    final trimmed = trim();
    if (trimmed.runes.length <= maxLength) return trimmed;
    return String.fromCharCodes(trimmed.runes.take(maxLength)).trimRight();
  }
}
