import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';

extension TransactionFormStateX on TransactionFormState {
  bool get isEdit => mode is EditTransactionMode;

  String get initialNote => switch (mode) {
    PrefillTransactionMode(:final draft) => draft.note ?? '',
    _ => original?.note ?? '',
  };

  bool isUnsure(String field) => unsure.contains(field);

  CategoryType get categoryType => switch (draft.type) {
    .income => CategoryType.income,
    .expense || .transfer => CategoryType.expense,
  };

  List<Category> get categories {
    final keep = original?.categoryId;
    return lookups.categories.values
        .where((c) => c.type == categoryType && (!c.isHidden || c.id == keep))
        .toList();
  }

  List<Wallet> get wallets {
    final keep = {original?.walletId, original?.toWalletId};
    return lookups.wallets.values
        .where((w) => !w.isArchived || keep.contains(w.id))
        .toList();
  }

  int? get changedFromAmount => switch (original) {
    final original? when original.amount != draft.amount => original.amount,
    _ => null,
  };

  FieldError? errorOf(String field) => errors[field];
}
