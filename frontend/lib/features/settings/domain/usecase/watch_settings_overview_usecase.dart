import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/domain/logic/settings_rules.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:rxdart/rxdart.dart';

/// The cached Settings hub for a month (the first of the month), rebuilt
/// whenever the user, the month's budget, the categories or the wallets
/// change.
///
/// A failed read of any section is passed on, and the stream keeps going.
class WatchSettingsOverviewUseCase
    implements StreamUseCase<SettingsOverview, DateTime> {
  WatchSettingsOverviewUseCase({
    required this._user,
    required this._budget,
    required this._categories,
    required this._wallets,
  });

  final WatchUserUseCase _user;
  final WatchBudgetUseCase _budget;
  final WatchCategoriesUseCase _categories;
  final WatchWalletsUseCase _wallets;

  @override
  Stream<Either<Failure, SettingsOverview>> call(DateTime month) =>
      Rx.combineLatest4(
        _user(const NoParams()),
        _budget(month),
        _categories(const NoParams()),
        _wallets(const NoParams()),
        (user, budget, categories, wallets) => user.flatMap(
          (user) => budget.flatMap(
            (budget) => categories.flatMap(
              (categories) => wallets.map(
                (wallets) => buildSettingsOverview(
                  user: user,
                  budget: budget,
                  categories: categories,
                  wallets: wallets,
                ),
              ),
            ),
          ),
        ),
      );
}
