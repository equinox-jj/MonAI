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
