part of 'receipt_review_bloc.dart';

@freezed
abstract class ReceiptReviewState with _$ReceiptReviewState {
  const factory ReceiptReviewState({
    required ReceiptReviewArgs args,
    required DateTime today,
    required ReceiptDraft draft,
    required TransactionType type,
    required DateTime date,
    String? walletId,
    String? categoryId,
    ReceiptAiFailure? aiFailure,
    @Default(false) bool isRetrying,

    /// Bumped when "Try again" brings a new [draft], so the screen refills
    /// its text fields.
    @Default(0) int draftVersion,
    ReceiptAiFailure? retryFailure,
    @Default({}) Map<ReceiptField, FieldMark> marks,
    @Default([]) List<Wallet> wallets,
    @Default([]) List<Category> allCategories,
    @Default({}) Map<String, FieldError> errors,
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    String? savedId,
    ReceiptFailure? actionFailure,
  }) = _ReceiptReviewState;
}

extension ReceiptReviewStateX on ReceiptReviewState {
  bool get aiFailed => aiFailure != null;

  List<ReceiptItem> get items => draft.items;

  int get itemsTotal => items.fold(0, (sum, item) => sum + (item.amount ?? 0));

  List<Category> get categories {
    final type = this.type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    return allCategories.where((c) => c.type == type && !c.isHidden).toList();
  }

  Category? get category =>
      allCategories.where((c) => c.id == categoryId).firstOrNull;

  Wallet? get wallet => wallets.where((w) => w.id == walletId).firstOrNull;

  FieldMark? markOf(ReceiptField field) => marks[field];

  FieldError? errorOf(ReceiptField field) => errors[field.apiField];
}
