import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/data/database/daos/budget_dao.dart';
import 'package:monai/core/data/database/daos/category_dao.dart';
import 'package:monai/core/data/database/daos/monthly_report_dao.dart';
import 'package:monai/core/data/database/daos/payment_provider_dao.dart';
import 'package:monai/core/data/database/daos/transaction_dao.dart';
import 'package:monai/core/data/database/daos/user_dao.dart';
import 'package:monai/core/data/database/daos/wallet_dao.dart';
import 'package:monai/core/data/database/tables/budgets_table.dart';
import 'package:monai/core/data/database/tables/categories_table.dart';
import 'package:monai/core/data/database/tables/monthly_reports_table.dart';
import 'package:monai/core/data/database/tables/payment_provider_catalog_table.dart';
import 'package:monai/core/data/database/tables/payment_providers_table.dart';
import 'package:monai/core/data/database/tables/report_categories_table.dart';
import 'package:monai/core/data/database/tables/transaction_remote_keys_table.dart';
import 'package:monai/core/data/database/tables/transactions_table.dart';
import 'package:monai/core/data/database/tables/users_table.dart';
import 'package:monai/core/data/database/tables/wallets_table.dart';
import 'package:monai/core/model/budget_status.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';

part 'monai_database.g.dart';

/// Offline read cache of the server's data. The API is the source of truth,
/// so a schema change drops and re-creates every table instead of migrating;
/// the app re-fills it from the server.
///
/// DAOs upsert rows as `row.toCompanion(false)`: a row class inserts with
/// null columns left out, so its upsert would never clear a nullable column.
@DriftDatabase(
  tables: [
    Wallets,
    Categories,
    Transactions,
    TransactionRemoteKeys,
    Budgets,
    PaymentProviders,
    PaymentProviderCatalog,
    MonthlyReports,
    ReportCategories,
    Users,
  ],
  daos: [
    WalletDao,
    CategoryDao,
    TransactionDao,
    BudgetDao,
    PaymentProviderDao,
    MonthlyReportDao,
    UserDao,
  ],
  include: {'tables/transactions_fts.drift'},
)
class MonAIDatabase extends _$MonAIDatabase {
  MonAIDatabase(super.executor);

  factory MonAIDatabase.open() => MonAIDatabase(driftDatabase(name: 'monai'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // Only a cache: drop it and let the server re-fill it. Reversed so
      // triggers and child tables go before what they depend on.
      for (final entity in allSchemaEntities.toList().reversed) {
        await m.drop(entity);
      }
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
