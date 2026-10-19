import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:monai/core/network/dio_client.dart';
import 'package:monai/core/network/interceptors/auth_interceptor.dart';
import 'package:monai/core/network/interceptors/unauthorized_interceptor.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/services/receipt_scanner_service.dart';
import 'package:monai/core/storage/token_storage.dart';
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
  sl.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<TokenStorage>()),
  );
  sl.registerLazySingleton<UnauthorizedInterceptor>(
    () => UnauthorizedInterceptor(
      tokenStorage: sl<TokenStorage>(),
      sessionManager: sl<SessionManager>(),
    ),
  );
  sl.registerLazySingleton<ReceiptScannerService>(
    ReceiptScannerServiceImpl.new,
  );
  sl.registerLazySingleton<Dio>(
    () => DioClient(
      authInterceptor: sl<AuthInterceptor>(),
      unauthorizedInterceptor: sl<UnauthorizedInterceptor>(),
    ).dio,
  );

  // ---- Features ----
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
