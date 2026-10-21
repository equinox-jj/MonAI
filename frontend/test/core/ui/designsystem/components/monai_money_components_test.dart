import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';

import '../../../../helpers/pump_themed.dart';

void main() {
  testWidgets('transaction row shows the amount with its arrow', (
    tester,
  ) async {
    // Arrange
    var taps = 0;
    await pumpThemed(
      tester,
      SizedBox(
        width: 360,
        child: MonAITransactionRow(
          title: 'Makan siang',
          meta: 'Food · GoPay · 12:40',
          amount: '−Rp 35.000',
          direction: .expense,
          categoryIcon: MonAIIcons.restaurant,
          categoryColor: CategoryColors.parse('#F97316'),
          onTap: () => taps++,
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Makan siang'));

    // Assert
    expect(find.text('Food · GoPay · 12:40'), findsOneWidget);
    expect(find.text('−Rp 35.000'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is MonAIIcon && w.icon == MonAIIcons.northEast,
      ),
      findsOneWidget,
    );
    expect(taps, 1);
  });

  testWidgets('wallet card shows the default pill only when given', (
    tester,
  ) async {
    // Arrange
    final gradient = WalletGradients.bank(dark: false);

    // Act
    await pumpThemed(
      tester,
      SizedBox(
        width: MonAISizes.walletCardWidth,
        height: MonAISizes.walletCardHeight,
        child: MonAIWalletCard(
          name: 'BCA Tabungan',
          monogram: 'BCA',
          gradient: gradient,
          balance: 'Rp 8.250.000',
          balanceLabel: 'Bank · balance',
          defaultLabel: 'Default',
        ),
      ),
    );

    // Assert
    expect(find.text('BCA'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Bank · balance'), findsOneWidget);
    expect(find.text('Rp 8.250.000'), findsOneWidget);
  });

  testWidgets('donut reads out its label', (tester) async {
    // Arrange
    const label = 'October spending: Food 60 percent, Bills 40 percent';

    // Act
    await pumpThemed(
      tester,
      const SizedBox.square(
        dimension: 140,
        child: MonAIDonut(
          shares: [60, 40],
          colors: [Colors.orange, Colors.purple],
          stroke: 17,
          semanticsLabel: label,
        ),
      ),
    );

    // Assert
    expect(find.bySemanticsLabel(label), findsOneWidget);
  });

  testWidgets('budget remaining warns near the limit', (tester) async {
    // Arrange
    const text = 'Rp 585.000 left';

    // Act
    await pumpThemed(
      tester,
      const MonAIBudgetRemaining(text: text, status: .warning),
    );

    // Assert
    expect(find.text(text), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is MonAIIcon && w.icon == MonAIIcons.warning,
      ),
      findsOneWidget,
    );
  });

  testWidgets('budget remaining on track has no icon', (tester) async {
    // Arrange
    const text = 'Rp 750.000 left';

    // Act
    await pumpThemed(
      tester,
      const MonAIBudgetRemaining(text: text, status: .ok),
    );

    // Assert
    expect(find.byType(MonAIIcon), findsNothing);
  });

  testWidgets('budget prompt card is tappable', (tester) async {
    // Arrange
    var taps = 0;
    await pumpThemed(
      tester,
      SizedBox(
        width: 360,
        child: MonAIBudgetPromptCard(
          title: 'No budget for October',
          body: 'Set a monthly limit.',
          actionLabel: 'Set',
          onTap: () => taps++,
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Set'));

    // Assert
    expect(find.text('No budget for October'), findsOneWidget);
    expect(taps, 1);
  });
}
