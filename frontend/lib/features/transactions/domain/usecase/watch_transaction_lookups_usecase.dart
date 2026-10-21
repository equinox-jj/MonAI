import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:rxdart/rxdart.dart';

/// Every cached category and wallet, to name what a transaction refers to;
/// updated whenever either cache changes. A failed read is passed on.
class WatchTransactionLookupsUseCase
    implements StreamUseCase<TransactionLookups, NoParams> {
  WatchTransactionLookupsUseCase({
    required this._categories,
    required this._wallets,
  });

  final WatchCategoriesUseCase _categories;
  final WatchAllWalletsUseCase _wallets;

  @override
  Stream<Either<Failure, TransactionLookups>> call(NoParams params) =>
      Rx.combineLatest2(
        _categories(const NoParams()),
        _wallets(const NoParams()),
        (categories, wallets) => categories.flatMap(
          (categories) => wallets.map(
            (wallets) =>
                TransactionLookups.of(categories: categories, wallets: wallets),
          ),
        ),
      );
}
