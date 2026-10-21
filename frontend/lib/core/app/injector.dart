import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:monai/core/data/database/daos/budget_dao.dart';
import 'package:monai/core/data/database/daos/category_dao.dart';
import 'package:monai/core/data/database/daos/monthly_report_dao.dart';
import 'package:monai/core/data/database/daos/payment_provider_dao.dart';
import 'package:monai/core/data/database/daos/transaction_dao.dart';
import 'package:monai/core/data/database/daos/user_dao.dart';
import 'package:monai/core/data/database/daos/wallet_dao.dart';
import 'package:monai/core/data/database/local_cache.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/network/dio_client.dart';
import 'package:monai/core/data/network/interceptors/auth_interceptor.dart';
import 'package:monai/core/data/network/interceptors/unauthorized_interceptor.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/data/services/app_info_service.dart';
import 'package:monai/core/data/services/avatar_photo_service.dart';
import 'package:monai/core/data/services/file_share_service.dart';
import 'package:monai/core/data/services/image_compressor_service.dart';
import 'package:monai/core/data/services/receipt_scanner_service.dart';
import 'package:monai/core/data/storage/app_preferences.dart';
import 'package:monai/core/data/storage/token_storage.dart';
import 'package:monai/features/auth/di/auth_di.dart';
import 'package:monai/features/budgets/di/budgets_di.dart';
import 'package:monai/features/categories/di/categories_di.dart';
import 'package:monai/features/export/di/export_di.dart';
import 'package:monai/features/home/di/home_di.dart';
import 'package:monai/features/profile/di/profile_di.dart';
import 'package:monai/features/quickadd/di/quickadd_di.dart';
import 'package:monai/features/receipt/di/receipt_di.dart';
import 'package:monai/features/reports/di/reports_di.dart';
import 'package:monai/features/settings/di/settings_di.dart';
import 'package:monai/features/shared/di/shared_di.dart';
import 'package:monai/features/transactions/di/transactions_di.dart';
import 'package:monai/features/wallets/di/wallets_di.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Registers every dependency. Call once before `runApp`.
///
/// Core services are registered here; each feature registers its own data
/// sources, repositories, use cases and blocs in its `*DI.init()`.
Future<void> configureDependencies() async {
  // ---- SharedPreferences ----
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ---- External ----
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SessionManager>(SessionManager.new);

  // ---- Core ----
  sl.registerLazySingleton<AppPreferences>(
    () => SharedAppPreferences(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<TokenStorage>()),
  );
  sl.registerLazySingleton<UnauthorizedInterceptor>(
    () => UnauthorizedInterceptor(
      tokenStorage: sl<TokenStorage>(),
      localCache: sl<LocalCache>(),
      sessionManager: sl<SessionManager>(),
    ),
  );
  sl.registerLazySingleton<ReceiptScannerService>(
    ReceiptScannerServiceImpl.new,
  );
  sl.registerLazySingleton<AppInfoService>(AppInfoServiceImpl.new);
  sl.registerLazySingleton<ImageCompressorService>(
    ImageCompressorServiceImpl.new,
  );
  sl.registerLazySingleton<AvatarPhotoService>(AvatarPhotoServiceImpl.new);
  sl.registerLazySingleton<FileShareService>(FileShareServiceImpl.new);
  sl.registerLazySingleton<Dio>(
    () => DioClient(
      authInterceptor: sl<AuthInterceptor>(),
      unauthorizedInterceptor: sl<UnauthorizedInterceptor>(),
    ).dio,
  );

  // ---- Database ----
  sl.registerLazySingleton<MonAIDatabase>(MonAIDatabase.open);
  sl.registerLazySingleton<WalletDao>(() => sl<MonAIDatabase>().walletDao);
  sl.registerLazySingleton<CategoryDao>(() => sl<MonAIDatabase>().categoryDao);
  sl.registerLazySingleton<TransactionDao>(
    () => sl<MonAIDatabase>().transactionDao,
  );
  sl.registerLazySingleton<BudgetDao>(() => sl<MonAIDatabase>().budgetDao);
  sl.registerLazySingleton<PaymentProviderDao>(
    () => sl<MonAIDatabase>().paymentProviderDao,
  );
  sl.registerLazySingleton<MonthlyReportDao>(
    () => sl<MonAIDatabase>().monthlyReportDao,
  );
  sl.registerLazySingleton<UserDao>(() => sl<MonAIDatabase>().userDao);
  sl.registerLazySingleton<LocalCache>(
    () => DriftLocalCache(sl<MonAIDatabase>()),
  );

  // ---- Features ----
  await SharedDI.init();
  await AuthDI.init();
  await ProfileDI.init();
  await SettingsDI.init();
  await WalletsDI.init();
  await CategoriesDI.init();
  await TransactionsDI.init();
  await BudgetsDI.init();
  await ReportsDI.init();
  await ReceiptDI.init();
  await QuickaddDI.init();
  await ExportDI.init();
  await HomeDI.init();
}
