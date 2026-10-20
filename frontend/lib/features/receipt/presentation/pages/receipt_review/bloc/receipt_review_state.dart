part of 'receipt_review_bloc.dart';

@freezed
abstract class ReceiptReviewState with _$ReceiptReviewState {
  const factory ReceiptReviewState({
    /// The photo and what the scanner read.
    required ReceiptReviewArgs args,

    /// The user's current date; later dates can't be picked.
    required DateTime today,

    /// What the AI read; replaced when "Try again" succeeds.
    required ReceiptDraft draft,

    /// Expense or income.
    required TransactionType type,

    /// Local midnight.
    required DateTime date,
    String? walletId,
    String? categoryId,

    /// Why the AI gave no draft; null once it read the receipt.
    ReceiptAiFailure? aiFailure,

    /// "Try again" is waiting for the AI.
    @Default(false) bool isRetrying,

    /// Bumped when "Try again" brings a new [draft], so the screen refills
    /// its text fields.
    @Default(0) int draftVersion,

    /// Why "Try again" failed; shown once as a snackbar.
    ReceiptAiFailure? retryFailure,

    /// The fields still as the AI filled them.
    @Default({}) Map<ReceiptField, FieldMark> marks,

    /// Active wallets, to pick from.
    @Default([]) List<Wallet> wallets,

    /// Every cached category; see [ReceiptReviewStateX.categories].
    @Default([]) List<Category> allCategories,

    /// One error per invalid field, keyed by the API's field name.
    @Default({}) Map<String, FieldError> errors,

    /// A save failed on the input, so errors update as the user edits.
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,

    /// Set once saved, as the new transaction's id; the screen leaves.
    String? savedId,

    /// Why a save failed; shown once as a snackbar.
    ReceiptFailure? actionFailure,
  }) = _ReceiptReviewState;
}

extension ReceiptReviewStateX on ReceiptReviewState {
  bool get aiFailed => aiFailure != null;

  List<ReceiptItem> get items => draft.items;

  /// The sum of the items that have an amount.
  int get itemsTotal => items.fold(0, (sum, item) => sum + (item.amount ?? 0));

  /// The visible categories of the chosen type, to pick from.
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
