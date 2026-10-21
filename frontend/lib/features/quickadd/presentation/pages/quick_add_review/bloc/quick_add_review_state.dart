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
