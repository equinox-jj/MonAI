import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/ui/designsystem/components/monai_marked_field.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_field.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/bloc/quick_add_review_bloc.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

extension QuickAddReviewStateX on QuickAddReviewState {
  List<QuickAddDraft> get drafts => args.drafts;

  bool get isDone => index >= drafts.length;

  bool get isLast => index == drafts.length - 1;

  QuickAddDraft? get original => isDone ? null : drafts[index];

  int get savedCount => results.whereType<SavedQuickAddResult>().length;

  List<Category> get categories {
    final type = current.type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    return allCategories.where((c) => c.type == type && !c.isHidden).toList();
  }

  Category? categoryOf(String? id) =>
      allCategories.where((c) => c.id == id).firstOrNull;

  Wallet? walletOf(String? id) => wallets.where((w) => w.id == id).firstOrNull;

  MonAIFieldMark? markOf(QuickAddField field) => marks[field];

  FieldError? errorOf(QuickAddField field) => errors[field.apiField];
}
