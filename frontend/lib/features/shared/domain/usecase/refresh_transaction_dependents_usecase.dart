import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

/// Re-fetches what the server recalculates after a transaction changes:
/// wallet balances, and the budget and report of each affected month. Best
/// effort, all at once: the change itself already succeeded, so this never
/// fails and a stale total heals on the next refresh. Gives whether every
/// refresh succeeded.
class RefreshTransactionDependentsUseCase
    implements UseCase<bool, List<DateTime>> {
  RefreshTransactionDependentsUseCase({
    required this._wallets,
    required this._budgets,
    required this._reports,
  });

  final WalletRepository _wallets;
  final BudgetRepository _budgets;
  final ReportRepository _reports;

  /// [months] are dates in the affected months; duplicates are refreshed
  /// once.
  @override
  Future<Either<Failure, bool>> call(List<DateTime> months) async {
    final firstDays = {
      for (final date in months) DateTime(date.year, date.month),
    };
    final results = await Future.wait<Either<Failure, Object?>>([
      _wallets.refreshWallets(),
      for (final month in firstDays) ...[
        _budgets.refreshBudget(month),
        _reports.refreshMonthlyReport(month),
      ],
    ]);
    return Right(results.every((result) => result.isRight()));
  }
}
