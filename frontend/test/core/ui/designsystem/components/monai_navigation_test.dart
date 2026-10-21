import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';

import '../../../../helpers/pump_themed.dart';

const _items = [
  MonAINavItem(label: 'Home', icon: MonAIIcons.home),
  MonAINavItem(label: 'Transactions', icon: MonAIIcons.receiptLong),
  MonAINavItem(label: 'Wallets', icon: MonAIIcons.accountBalanceWallet),
  MonAINavItem(label: 'Settings', icon: MonAIIcons.settings),
];

/// The height left beside an open keyboard on an 11-inch iPad.
const _shortHeight = 336.0;

void main() {
  testWidgets('the drawer fits a short window without overflowing', (
    tester,
  ) async {
    // Arrange
    final drawer = SizedBox(
      height: _shortHeight,
      child: MonAINavigationDrawer(
        title: 'MonAI',
        items: _items,
        selectedIndex: 0,
        onSelect: (_) {},
        onAdd: () {},
        addLabel: 'Add transaction',
      ),
    );

    // Act
    await pumpThemed(tester, drawer);

    // Assert
    expect(tester.takeException(), isNull);
  });

  testWidgets('the rail fits a short window without overflowing', (
    tester,
  ) async {
    // Arrange
    final rail = SizedBox(
      height: _shortHeight,
      child: MonAINavigationRail(
        items: _items,
        selectedIndex: 0,
        onSelect: (_) {},
        onAdd: () {},
        addLabel: 'Add transaction',
      ),
    );

    // Act
    await pumpThemed(tester, rail);

    // Assert
    expect(tester.takeException(), isNull);
  });
}
