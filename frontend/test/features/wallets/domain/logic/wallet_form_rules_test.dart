import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/wallets/domain/logic/wallet_form_rules.dart';

import '../../../../helpers/entity_fixtures.dart';

const _bca = PaymentProvider(
  id: 'p-bca',
  slug: 'bca',
  name: 'BCA',
  type: WalletType.bank,
  aliases: [],
  sortOrder: 10,
);

void main() {
  test('shiftedBalance moves the current balance with the starting one', () {
    // Arrange
    final edited = wallet(initialBalance: 2000000, currentBalance: 2565000);

    // Act
    final shifted = shiftedBalance(edited, 2500000);

    // Assert
    expect(shifted, 3065000);
  });

  group('newWalletInput', () {
    test('a custom wallet sends its own name and type', () {
      // Act
      final input = newWalletInput(
        provider: null,
        name: 'Tabungan rumah',
        type: WalletType.other,
        initialBalance: 5000,
        isDefault: true,
      );

      // Assert
      expect(
        input,
        const WalletInput(
          name: 'Tabungan rumah',
          type: WalletType.other,
          initialBalance: 5000,
          isDefault: true,
        ),
      );
    });

    test('a provider wallet leaves the type to the server', () {
      // Act
      final input = newWalletInput(
        provider: _bca,
        name: 'BCA Bisnis',
        type: WalletType.bank,
        initialBalance: 0,
        isDefault: false,
      );

      // Assert
      expect(input.providerId, 'p-bca');
      expect(input.type, isNull);
      expect(input.name, 'BCA Bisnis');
    });

    test('a bundled provider goes as custom with its name and type', () {
      // Arrange
      final bundled = _bca.copyWith(id: 'seed:bca', isBundled: true);

      // Act
      final input = newWalletInput(
        provider: bundled,
        name: '  ',
        type: null,
        initialBalance: 0,
        isDefault: false,
      );

      // Assert
      expect(input.providerId, isNull);
      expect(input.name, 'BCA');
      expect(input.type, WalletType.bank);
    });
  });

  test('dailyOutflowSeries fills days without money out with 0', () {
    // Arrange
    final outflows = {DateTime(2026, 10, 2): 5000, DateTime(2026, 10, 4): 700};

    // Act
    final series = dailyOutflowSeries(outflows, DateTime(2026, 10), 4);

    // Assert
    expect(series, [0, 5000, 0, 700]);
  });
}
