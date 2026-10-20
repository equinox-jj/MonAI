import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_user_usecase.dart';

/// Re-fetches the user, the month's budget (the first of the month) and the
/// categories in parallel into the cache. Wallets come from Home's refresh.
///
/// Always returns [Right]: a section that fails keeps its cached data, and
/// every row has a sensible empty value.
class RefreshSettingsUseCase implements UseCase<Unit, DateTime> {
  RefreshSettingsUseCase({
    required this._user,
    required this._budget,
    required this._categories,
  });

  final RefreshUserUseCase _user;
  final RefreshBudgetUseCase _budget;
  final RefreshCategoriesUseCase _categories;

  @override
  Future<Either<Failure, Unit>> call(DateTime month) async {
    await Future.wait<Either<Failure, Object?>>([
      _user(const NoParams()),
      _budget(month),
      _categories(const NoParams()),
    ]);
    return const Right(unit);
  }
}
