import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/categories/domain/logic/category_rules.dart';

import '../../../../helpers/entity_fixtures.dart';

void main() {
  final food = category(id: 'food', name: 'Food');
  final kopi = category(id: 'kopi', name: 'kopi', isDefault: false);
  final hiddenKopi = category(
    id: 'kopi',
    name: 'Kopi',
    isDefault: false,
    isHidden: true,
  );
  final other = category(id: 'other', name: 'Other', isSystem: true);

  test('default categories hide but never delete', () {
    // Assert
    expect(food.kind, CategoryKind.standard);
    expect(food.canToggleHidden, isTrue);
    expect(food.canDelete, isFalse);
    expect(food.canEdit, isTrue);
  });

  test('custom categories delete, and only show again once hidden', () {
    // Assert
    expect(kopi.canDelete, isTrue);
    expect(kopi.canToggleHidden, isFalse);
    expect(hiddenKopi.canToggleHidden, isTrue);
  });

  test('"Other" can be neither hidden, deleted nor edited', () {
    // Assert
    expect(other.kind, CategoryKind.system);
    expect(other.canToggleHidden, isFalse);
    expect(other.canDelete, isFalse);
    expect(other.canEdit, isFalse);
  });

  test('sorts by name ignoring case with "Other" last', () {
    // Act
    final sorted = sortCategories([other, kopi, food]);

    // Assert
    expect(sorted.map((c) => c.id), ['food', 'kopi', 'other']);
  });

  test('moves go to visible categories of the same type, "Other" first', () {
    // Arrange
    final salary = category(id: 'salary', type: CategoryType.income);
    final hidden = category(id: 'movie', name: 'Movie', isHidden: true);

    // Act
    final targets = moveTargets(kopi, [food, kopi, other, salary, hidden]);

    // Assert
    expect(targets.map((c) => c.id), ['other', 'food']);
  });
}
