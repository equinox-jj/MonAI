import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/widgets/transaction_detail_receipt.dart';

void main() {
  testWidgets('the photo area fills the screen, not the close button', (
    tester,
  ) async {
    // Arrange
    final screen = tester.view.physicalSize / tester.view.devicePixelRatio;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        theme: MonAITheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TransactionReceiptViewer(url: 'https://x/receipt.jpg'),
      ),
    );

    // Assert
    expect(tester.getSize(find.byType(InteractiveViewer)), screen);
  });
}
