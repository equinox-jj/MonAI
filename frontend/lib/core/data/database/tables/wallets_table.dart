import 'package:drift/drift.dart';
import 'package:monai/core/model/wallet_type.dart';

/// The user's wallets, balances as calculated by the server.
@DataClassName('WalletRow')
class Wallets extends Table {
  TextColumn get id => text()();
  TextColumn get providerId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<WalletType>()();
  TextColumn get logoUrl => text().nullable()();

  /// Rupiah.
  IntColumn get initialBalance => integer()();

  /// Rupiah.
  IntColumn get currentBalance => integer()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get isDefault => boolean()();
  BoolColumn get isArchived => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
