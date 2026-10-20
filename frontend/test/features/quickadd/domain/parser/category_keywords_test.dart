import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/quickadd/domain/parser/category_keywords.dart';

import '../../../../helpers/entity_fixtures.dart';

final _categories = [
  category(id: 'food'),
  category(id: 'transport', name: 'Transport'),
  category(id: 'pets', name: 'Kucing', isDefault: false),
  category(id: 'salary', name: 'Salary', type: CategoryType.income),
];

CategoryMatch? _find(String text, [CategoryType type = CategoryType.expense]) =>
    CategoryKeywords.find(text, _categories, type);

void main() {
  group('CategoryKeywords', () {
    test("the user's own category name beats keywords", () {
      // Act
      final match = _find('makanan kucing 50rb');

      // Assert
      expect(match?.categoryId, 'pets');
      expect(match?.confidence, CategoryKeywords.named);
    });

    test('keywords map onto default categories', () {
      // Act
      final coffee = _find('ngopi 25rb');
      final fuel = _find('isi bensin');
      final payday = _find('gajian', CategoryType.income);

      // Assert
      expect(coffee?.categoryId, 'food');
      expect(coffee?.confidence, CategoryKeywords.keyword);
      expect(fuel?.categoryId, 'transport');
      expect(payday?.categoryId, 'salary');
    });

    test('the earliest keyword wins', () {
      // Act
      final match = _find('parkir di resto');

      // Assert
      expect(match?.categoryId, 'transport');
    });

    test('keywords for the other type or a missing category match nothing', () {
      // Act
      final otherType = _find('gajian');
      final missing = _find('obat');

      // Assert
      expect(otherType, isNull);
      expect(missing, isNull);
    });
  });
}
