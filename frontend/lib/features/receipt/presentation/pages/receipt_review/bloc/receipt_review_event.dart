part of 'receipt_review_bloc.dart';

@freezed
sealed class ReceiptReviewEvent with _$ReceiptReviewEvent {
  /// The review opened.
  const factory ReceiptReviewEvent.started() = _Started;

  /// Expense or income; a transfer is ignored.
  const factory ReceiptReviewEvent.typeSelected(TransactionType type) =
      _TypeSelected;

  const factory ReceiptReviewEvent.categoryPicked(String categoryId) =
      _CategoryPicked;

  const factory ReceiptReviewEvent.walletPicked(String walletId) =
      _WalletPicked;

  /// [date] is local midnight.
  const factory ReceiptReviewEvent.datePicked(DateTime date) = _DatePicked;

  /// The amount field changed to [text], e.g. `187.500`.
  const factory ReceiptReviewEvent.amountEdited(String text) = _AmountEdited;

  const factory ReceiptReviewEvent.merchantEdited(String text) =
      _MerchantEdited;

  const factory ReceiptReviewEvent.noteEdited(String text) = _NoteEdited;

  /// Save, with the text fields' text.
  const factory ReceiptReviewEvent.saveRequested({
    required String amount,
    required String merchant,
    required String note,
  }) = _SaveRequested;

  /// "Try again" after the AI failed: sends the receipt's text again.
  const factory ReceiptReviewEvent.retryRequested() = _RetryRequested;

  /// The cached active wallets changed. Sent by the bloc itself.
  const factory ReceiptReviewEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;

  /// The cached categories changed. Sent by the bloc itself.
  const factory ReceiptReviewEvent.categoriesChanged(
    List<Category> categories,
  ) = _CategoriesChanged;
}
