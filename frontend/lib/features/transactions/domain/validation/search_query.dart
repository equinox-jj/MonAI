// The one place search text is cleaned up, matching the server's `q` rules.

extension SearchQuery on String {
  static const maxLength = 100;

  String get normalizedSearch {
    final trimmed = trim();
    if (trimmed.runes.length <= maxLength) return trimmed;
    return String.fromCharCodes(trimmed.runes.take(maxLength)).trimRight();
  }
}
