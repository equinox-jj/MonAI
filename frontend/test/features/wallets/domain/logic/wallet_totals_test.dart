import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/wallets/domain/logic/wallet_totals.dart';

import '../../../../helpers/entity_fixtures.dart';

void main() {
  test('sums the balances and splits them by type, biggest first', () {
    // Arrange
    final wallets = [
      wallet(id: 'w1', type: WalletType.bank, currentBalance: 8250000),
      wallet(id: 'w2', type: WalletType.bank, currentBalance: 2565000),
      wallet(id: 'w3', type: WalletType.eWallet, currentBalance: 1185000),
      wallet(id: 'w4', currentBalance: 450000),
    ];

    // Act
    final totals = walletTotalsOf(wallets);

    // Assert
    expect(totals.total, 12450000);
    expect(totals.shares.map((s) => (s.type, s.percent)), [
      (WalletType.bank, 87),
      (WalletType.eWallet, 9),
      (WalletType.cash, 4),
    ]);
  });

  test('the shown percents always add up to 100', () {
    // Arrange
    final wallets = [
      wallet(id: 'w1', type: WalletType.bank, currentBalance: 1),
      wallet(id: 'w2', type: WalletType.eWallet, currentBalance: 1),
      wallet(id: 'w3', currentBalance: 1),
    ];

    // Act
    final shares = walletTotalsOf(wallets).shares;

    // Assert
    expect(shares.fold<int>(0, (sum, s) => sum + s.percent), 100);
  });

  test('a negative balance counts in the total but not in the split', () {
    // Arrange
    final wallets = [
      wallet(id: 'w1', type: WalletType.bank, currentBalance: 100000),
      wallet(id: 'w2', currentBalance: -20000),
    ];

    // Act
    final totals = walletTotalsOf(wallets);

    // Assert
    expect(totals.total, 80000);
    expect(totals.shares.single.type, WalletType.bank);
    expect(totals.shares.single.percent, 100);
  });

  test('no money anywhere gives no split', () {
    // Arrange
    final wallets = [wallet(currentBalance: 0)];

    // Act
    final totals = walletTotalsOf(wallets);

    // Assert
    expect(totals.total, 0);
    expect(totals.shares, isEmpty);
  });
}
