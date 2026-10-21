import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

part 'transaction_lookups.freezed.dart';

/// Archived wallets and hidden categories are included, so old transactions
/// still show their names.
@freezed
abstract class TransactionLookups with _$TransactionLookups {
  const factory TransactionLookups({
    @Default({}) Map<String, Category> categories,
    @Default({}) Map<String, Wallet> wallets,
  }) = _TransactionLookups;

  const TransactionLookups._();

  factory TransactionLookups.of({
    required List<Category> categories,
    required List<Wallet> wallets,
  }) => TransactionLookups(
    categories: {for (final category in categories) category.id: category},
    wallets: {for (final wallet in wallets) wallet.id: wallet},
  );

  Category? category(String? id) => id == null ? null : categories[id];

  Wallet? wallet(String? id) => id == null ? null : wallets[id];

  List<Wallet> get allWallets => wallets.values.toList();

  List<Wallet> get activeWallets =>
      wallets.values.where((wallet) => !wallet.isArchived).toList();

  List<Category> get visibleCategories =>
      categories.values.where((category) => !category.isHidden).toList();
}
