/// The characters `[start, end)` of a phrase that a parser read.
class TextSpan {
  const TextSpan(this.start, this.end);

  final int start;
  final int end;

  bool overlaps(TextSpan other) => start < other.end && other.start < end;

  bool contains(int index) => index >= start && index < end;

  @override
  bool operator ==(Object other) =>
      other is TextSpan && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'TextSpan($start, $end)';
}

/// A whole-word pattern: [pattern] not glued to a word character (or
/// [extra] characters) on either side.
RegExp wordPattern(String pattern, {String extra = ''}) =>
    RegExp('(?<![\\w$extra])(?:$pattern)(?![\\w$extra])');
