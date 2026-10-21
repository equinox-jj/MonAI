part of 'quick_add_review_bloc.dart';

@freezed
abstract class QuickAddReviewState with _$QuickAddReviewState {
  const factory QuickAddReviewState({
    required QuickAddReviewArgs args,
    required DateTime today,
    @Default(0) int index,
    required QuickAddDraft current,
    @Default([]) List<QuickAddReviewResult> results,
    @Default({}) Map<QuickAddField, MonAIFieldMark> marks,
    @Default([]) List<Wallet> wallets,
    @Default([]) List<Category> allCategories,
    @Default({}) Map<String, FieldError> errors,
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    QuickAddSaveFailure? actionFailure,
  }) = _QuickAddReviewState;
}

@freezed
sealed class QuickAddReviewResult with _$QuickAddReviewResult {
  const factory QuickAddReviewResult.saved(Transaction transaction) =
      SavedQuickAddResult;

  const factory QuickAddReviewResult.skipped() = SkippedQuickAddResult;
}

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
