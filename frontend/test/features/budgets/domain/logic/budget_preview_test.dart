import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/budget_status.dart';
import 'package:monai/features/budgets/domain/logic/budget_preview.dart';

void main() {
  test('no limit gives no preview', () {
    // Act
    final preview = BudgetPreview.of(limit: 0, spent: 2415000);

    // Assert
    expect(preview, isNull);
  });

  for (final (spent, status, percent) in [
    (2399999, BudgetStatus.ok, 79),
    (2400000, BudgetStatus.warning, 80),
    (3000000, BudgetStatus.warning, 100),
    (3000001, BudgetStatus.exceeded, 100),
  ]) {
    test('Rp $spent of Rp 3.000.000 is $status at $percent%', () {
      // Act
      final preview = BudgetPreview.of(limit: 3000000, spent: spent)!;

      // Assert
      expect(preview.status, status);
      expect(preview.percent, percent);
      expect(preview.remaining, 3000000 - spent);
    });
  }

  test('the bar stops at full when over the limit', () {
    // Act
    final preview = BudgetPreview.of(limit: 1000, spent: 1500)!;

    // Assert
    expect(preview.progress, 1);
    expect(preview.percent, 150);
    expect(preview.remaining, -500);
  });
}
