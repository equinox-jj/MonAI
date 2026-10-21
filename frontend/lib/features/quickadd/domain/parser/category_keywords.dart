import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/quickadd/domain/parser/text_span.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

class CategoryMatch {
  const CategoryMatch(this.categoryId, this.confidence);

  final String categoryId;
  final double confidence;
}

class _Group {
  const _Group(this.categoryNames, this.keywords);
  final List<String> categoryNames;
  final List<String> keywords;
}

/// Guesses a category from words in a phrase: the user's own category names
/// first, then a keyword map onto the default categories (matched by their
/// English or Indonesian name).
abstract final class CategoryKeywords {
  static const named = 0.95;
  static const keyword = 0.85;

  static const _groups = [
    _Group(
      ['food', 'makanan', 'makan', 'food & drink', 'makan & minum'],
      [
        'makan', 'sarapan', 'makan siang', 'makan malam', 'nasi', 'kopi', //
        'ngopi', 'bakso', 'mie', 'mi ayam', 'sate', 'ayam', 'jajan', 'snack',
        'cemilan', 'minum', 'teh', 'es teh', 'boba', 'gofood', 'grabfood',
        'shopeefood', 'resto', 'restoran', 'warteg', 'warung', 'padang',
        'pizza', 'burger', 'roti', 'kue', 'martabak', 'seblak', 'gorengan',
        'lunch', 'dinner', 'breakfast', 'coffee', 'food', 'starbucks',
      ],
    ),
    _Group(
      ['transport', 'transportasi'],
      [
        'parkir', 'bensin', 'bbm', 'pertalite', 'pertamax', 'solar', 'ojek', //
        'ojol', 'gojek', 'goride', 'gocar', 'grab', 'grabbike', 'grabcar',
        'taksi', 'taxi', 'tol', 'e-toll', 'kereta', 'krl', 'mrt', 'lrt',
        'transjakarta', 'busway', 'bus', 'angkot', 'parking', 'fuel', 'uber',
        'bengkel', 'ganti oli', 'servis motor', 'servis mobil', 'cuci motor',
        'cuci mobil',
      ],
    ),
    _Group(
      ['bills', 'tagihan', 'bill'],
      [
        'listrik', 'pln', 'token', 'pdam', 'pulsa', 'kuota', 'paket data', //
        'internet', 'wifi', 'indihome', 'bpjs', 'cicilan', 'tagihan', 'sewa',
        'kos', 'kost', 'kontrakan', 'iuran', 'electricity', 'rent',
      ],
    ),
    _Group(
      ['shopping', 'belanja'],
      [
        'belanja', 'baju', 'celana', 'sepatu', 'tas', 'shopee', 'tokopedia', //
        'tokped', 'lazada', 'alfamart', 'indomaret', 'supermarket',
        'groceries', 'sabun', 'skincare', 'shopping',
      ],
    ),
    _Group(
      ['health', 'kesehatan'],
      [
        'obat', 'apotek', 'apotik', 'dokter', 'rumah sakit', 'klinik', //
        'vitamin', 'medicine', 'doctor', 'pharmacy', 'gym', 'fitness',
      ],
    ),
    _Group(
      ['entertainment', 'hiburan'],
      [
        'nonton', 'bioskop', 'film', 'game', 'karaoke', 'konser', 'liburan', //
        'movie', 'cinema', 'concert', 'netflix', 'spotify', 'disney',
        'youtube premium',
      ],
    ),
    _Group(['salary', 'gaji'], ['gaji', 'gajian', 'salary', 'payroll']),
    _Group(['bonus'], ['bonus', 'thr', 'insentif', 'komisi']),
  ];

  /// Several hits pick the earliest in the text.
  static CategoryMatch? find(
    String text,
    List<Category> categories,
    CategoryType type,
  ) {
    final byName = {
      for (final c in categories.where((c) => c.type == type))
        c.name.toLowerCase().trim(): c,
    };

    final namedHit = _earliest([
      for (final MapEntry(key: name, value: category) in byName.entries)
        if (_firstIndexOf(name, text) case final index?) (index, category),
    ]);
    if (namedHit != null) return CategoryMatch(namedHit.id, named);

    final keywordHit = _earliest([
      for (final group in _groups)
        if (group.categoryNames.map((n) => byName[n]).nonNulls.firstOrNull
            case final category?)
          if (_firstKeyword(group.keywords, text) case final index?)
            (index, category),
    ]);
    return keywordHit == null ? null : CategoryMatch(keywordHit.id, keyword);
  }

  static Category? _earliest(List<(int, Category)> hits) {
    if (hits.isEmpty) return null;
    return hits.reduce((a, b) => b.$1 < a.$1 ? b : a).$2;
  }

  static int? _firstKeyword(List<String> keywords, String text) {
    final indexes = keywords.map((k) => _firstIndexOf(k, text)).nonNulls;
    return indexes.isEmpty ? null : indexes.reduce((a, b) => a < b ? a : b);
  }

  static int? _firstIndexOf(String word, String text) =>
      wordPattern(RegExp.escape(word), extra: '-').firstMatch(text)?.start;
}
