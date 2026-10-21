import 'package:fpdart/fpdart.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/domain/logic/home_dashboard_rules.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';
import 'package:rxdart/rxdart.dart';

/// The cached dashboard for the month of the given moment, rebuilt whenever
/// any section's cache changes. The moment also picks the greeting and what
/// counts as "today".
///
/// A failed read of any section is passed on, and the stream keeps going.
class WatchHomeDashboardUseCase
    implements StreamUseCase<HomeDashboard, DateTime> {
  WatchHomeDashboardUseCase({
    required this._user,
    required this._wallets,
    required this._categories,
    required this._recent,
    required this._budget,
    required this._report,
  });

  final WatchUserUseCase _user;
  final WatchAllWalletsUseCase _wallets;
  final WatchCategoriesUseCase _categories;
  final WatchRecentTransactionsUseCase _recent;
  final WatchBudgetUseCase _budget;
  final WatchMonthlyReportUseCase _report;

  @override
  Stream<Either<Failure, HomeDashboard>> call(DateTime now) {
    final month = monthOf(now);
    return Rx.combineLatest6(
      _user(const NoParams()),
      _wallets(const NoParams()),
      _categories(const NoParams()),
      _recent(
        RecentTransactionsParams(month: month, limit: kRecentTransactionLimit),
      ),
      _budget(month),
      _report(month),
      (user, wallets, categories, recent, budget, report) => user.flatMap(
        (user) => wallets.flatMap(
          (wallets) => categories.flatMap(
            (categories) => recent.flatMap(
              (recent) => budget.flatMap(
                (budget) => report.map(
                  (report) => buildHomeDashboard(
                    now: now,
                    user: user,
                    wallets: wallets,
                    categories: categories,
                    recent: recent,
                    budget: budget,
                    report: report,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
