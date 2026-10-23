import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_field.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

extension ReceiptReviewStateX on ReceiptReviewState {
  bool get aiFailed => aiFailure != null;

  List<ReceiptItem> get items => draft.items;

  int get itemsTotal => items.fold(0, (sum, item) => sum + (item.amount ?? 0));

  CategoryType get categoryType => type == TransactionType.income
      ? CategoryType.income
      : CategoryType.expense;

  List<Category> get categories => allCategories
      .where((c) => c.type == categoryType && !c.isHidden)
      .toList();

  Category? get category =>
      allCategories.where((c) => c.id == categoryId).firstOrNull;

  Wallet? get wallet => wallets.where((w) => w.id == walletId).firstOrNull;

  FieldMark? markOf(ReceiptField field) => marks[field];

  FieldError? errorOf(ReceiptField field) => errors[field.apiField];
}
