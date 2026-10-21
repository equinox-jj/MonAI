import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/home/domain/logic/home_dashboard_rules.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';

/// Why a Home refresh failed.
enum HomeLoadFailure {
  /// No connection or a timeout.
  network,

  /// Anything else.
  unexpected,
}

/// What a Home refresh fetched.
class HomeRefreshResult {
  const HomeRefreshResult({
    required this.budgetLoaded,
    required this.recentLoaded,
    this.failure,
  });

  /// The month's budget was fetched, so a missing one means "not set".
  final bool budgetLoaded;

  /// The month's transactions were fetched, so an empty list means "none
  /// yet".
  final bool recentLoaded;

  /// Null when every section refreshed. Being offline explains every other
  /// failure, so [HomeLoadFailure.network] wins.
  final HomeLoadFailure? failure;
}

/// Re-fetches every Home section of the month (the first of the month) in
/// parallel into the cache.
///
/// Always returns [Right]: a section that fails keeps its cached data and is
/// reported in [HomeRefreshResult.failure].
class RefreshHomeUseCase implements UseCase<HomeRefreshResult, DateTime> {
  RefreshHomeUseCase({
    required this._user,
    required this._wallets,
    required this._categories,
    required this._recent,
    required this._budget,
    required this._report,
  });

  final RefreshUserUseCase _user;
  final RefreshWalletsUseCase _wallets;
  final RefreshCategoriesUseCase _categories;
  final RefreshRecentTransactionsUseCase _recent;
  final RefreshBudgetUseCase _budget;
  final RefreshMonthlyReportUseCase _report;

  @override
  Future<Either<Failure, HomeRefreshResult>> call(DateTime month) async {
    final budget = _budget(month);
    final recent = _recent(
      RecentTransactionsParams(month: month, limit: kRecentTransactionLimit),
    );
    final results = await Future.wait<Either<Failure, Object?>>([
      budget,
      recent,
      _user(const NoParams()),
      _wallets(const NoParams()),
      _categories(const NoParams()),
      _report(month),
    ]);
    final failures = results.map((r) => r.getLeft().toNullable()).nonNulls;
    return Right(
      HomeRefreshResult(
        budgetLoaded: results[0].isRight(),
        recentLoaded: results[1].isRight(),
        failure: switch (failures) {
          _ when failures.isEmpty => null,
          _ when failures.any(_isNetwork) => .network,
          _ => .unexpected,
        },
      ),
    );
  }

  static bool _isNetwork(Failure failure) =>
      failure is NetworkFailure || failure is TimeoutFailure;
}
