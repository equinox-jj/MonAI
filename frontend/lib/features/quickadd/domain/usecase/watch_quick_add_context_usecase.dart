import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/shared/domain/usecase/watch_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_visible_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:rxdart/rxdart.dart';

/// What the phone-side parser matches: active wallets, visible categories
/// of both types and the provider catalog's aliases, dated today. Updated
/// whenever a cache changes; a failed read is passed on.
class WatchQuickAddContextUseCase
    implements StreamUseCase<ParseContext, NoParams> {
  /// [now] is the clock; tests pass a fixed one.
  WatchQuickAddContextUseCase({
    required this._wallets,
    required this._categories,
    required this._providers,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final WatchWalletsUseCase _wallets;
  final WatchVisibleCategoriesUseCase _categories;
  final WatchPaymentProvidersUseCase _providers;
  final DateTime Function() _now;

  @override
  Stream<Either<Failure, ParseContext>> call(NoParams params) =>
      Rx.combineLatest4(
        _wallets(const NoParams()),
        _categories(CategoryType.expense),
        _categories(CategoryType.income),
        _providers(const NoParams()),
        (wallets, expense, income, providers) {
          final now = _now();
          return wallets.flatMap(
            (wallets) => expense.flatMap(
              (expense) => income.flatMap(
                (income) => providers.map(
                  (providers) => ParseContext(
                    wallets: wallets,
                    categories: [...expense, ...income],
                    providers: providers,
                    today: DateTime(now.year, now.month, now.day),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
