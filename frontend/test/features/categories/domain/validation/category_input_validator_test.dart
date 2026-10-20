import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/categories/domain/validation/category_input_validator.dart';

void main() {
  test('a blank name is required', () {
    // Act
    final error = CategoryInputValidator.name('   ');

    // Assert
    expect(error?.code, 'required');
  });

  test('a name over 30 characters is too long', () {
    // Act
    final error = CategoryInputValidator.name('a' * 31);

    // Assert
    expect(error?.code, 'max');
    expect(error?.params['max'], 30);
  });

  test('30 characters with spaces around them is fine', () {
    // Act
    final error = CategoryInputValidator.name('  ${'a' * 30}  ');

    // Assert
    expect(error, isNull);
  });
}
