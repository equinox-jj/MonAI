import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_seed_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the bundled catalog with seed ids', () async {
    // Arrange
    final source = PaymentProviderSeedDataSourceImpl(bundle: rootBundle);

    // Act
    final rows = await source.load();

    // Assert
    expect(rows.map((row) => row.slug), containsAll(['cash', 'bca', 'gopay']));
    expect(rows.every((row) => row.id.startsWith(seedIdPrefix)), isTrue);
    expect(
      rows.firstWhere((row) => row.slug == 'gopay').type,
      WalletType.eWallet,
    );
    expect(rows.firstWhere((row) => row.slug == 'cash').type, WalletType.cash);
  });
}
