import 'package:drift/drift.dart';
import 'package:monai/core/database/converters.dart';
import 'package:monai/core/model/wallet_type.dart';

/// The catalog of banks and e-wallets a wallet can be linked to.
@DataClassName('PaymentProviderRow')
class PaymentProviders extends Table {
  TextColumn get id => text()();
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<WalletType>()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get aliases => text().map(const StringListConverter())();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
