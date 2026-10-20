final _whitespace = RegExp(r'\s+');

List<String> _words(String name) =>
    name.trim().split(_whitespace).where((w) => w.isNotEmpty).toList();

/// `JP` for "Joshua Putra Jeremia": the first letters of the first two
/// words, uppercased.
String initialsOf(String name) =>
    _words(name).take(2).map((w) => w[0].toUpperCase()).join();

/// A wallet's logo stand-in: `BCA` for "BCA Tabungan", `GP` for "GoPay",
/// `BJ` for "Bank Jago".
String walletMonogram(String name) {
  final words = _words(name);
  if (words.isEmpty) return '';
  final first = words.first;
  if (first.length <= 3) return first.toUpperCase();
  if (words.length > 1) return initialsOf(name);
  final capitals = first.split('').where((ch) {
    return ch != ch.toLowerCase() && ch == ch.toUpperCase();
  }).join();
  return capitals.length >= 2
      ? capitals.substring(0, 2)
      : first.substring(0, 2).toUpperCase();
}
