part of 'quick_add_review_bloc.dart';

@freezed
abstract class QuickAddReviewState with _$QuickAddReviewState {
  const factory QuickAddReviewState({
    required QuickAddReviewArgs args,

    /// The user's current date; later dates can't be picked.
    required DateTime today,

    /// The draft on screen; [QuickAddReviewStateX.isDone] past the last.
    @Default(0) int index,

    /// The choices for the draft on screen; the amount and note live in
    /// the screen's text fields.
    required QuickAddDraft current,

    /// What happened to each draft before [index].
    @Default([]) List<QuickAddReviewResult> results,

    /// The fields of [current] still as quick add filled them.
    @Default({}) Map<QuickAddField, MonAIFieldMark> marks,

    /// Active wallets, to pick from.
    @Default([]) List<Wallet> wallets,

    /// Every cached category; see [QuickAddReviewStateX.categories].
    @Default([]) List<Category> allCategories,

    /// One error per invalid field, keyed by the API's field name.
    @Default({}) Map<String, FieldError> errors,

    /// A save failed on the input, so errors update as the user edits.
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,

    /// Why a save failed; shown once as a snackbar.
    QuickAddSaveFailure? actionFailure,
  }) = _QuickAddReviewState;
}

/// What the user did with one draft.
@freezed
sealed class QuickAddReviewResult with _$QuickAddReviewResult {
  /// Saved as [transaction].
  const factory QuickAddReviewResult.saved(Transaction transaction) =
      SavedQuickAddResult;

  const factory QuickAddReviewResult.skipped() = SkippedQuickAddResult;
}

extension QuickAddReviewStateX on QuickAddReviewState {
  List<QuickAddDraft> get drafts => args.drafts;

  bool get isDone => index >= drafts.length;

  bool get isLast => index == drafts.length - 1;

  /// The draft on screen as quick add read it.
  QuickAddDraft? get original => isDone ? null : drafts[index];

  int get savedCount => results.whereType<SavedQuickAddResult>().length;

  /// The visible categories of the draft's type, to pick from.
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
