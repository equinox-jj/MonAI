part of 'receipt_review_bloc.dart';

@freezed
sealed class ReceiptReviewEvent with _$ReceiptReviewEvent {
  const factory ReceiptReviewEvent.started() = _Started;

  const factory ReceiptReviewEvent.typeSelected(TransactionType type) =
      _TypeSelected;

  const factory ReceiptReviewEvent.categoryPicked(String categoryId) =
      _CategoryPicked;

  const factory ReceiptReviewEvent.walletPicked(String walletId) =
      _WalletPicked;

  const factory ReceiptReviewEvent.datePicked(DateTime date) = _DatePicked;
  const factory ReceiptReviewEvent.amountEdited(String text) = _AmountEdited;

  const factory ReceiptReviewEvent.merchantEdited(String text) =
      _MerchantEdited;

  const factory ReceiptReviewEvent.noteEdited(String text) = _NoteEdited;

  const factory ReceiptReviewEvent.saveRequested({
    required String amount,
    required String merchant,
    required String note,
  }) = _SaveRequested;

  const factory ReceiptReviewEvent.retryRequested() = _RetryRequested;

  const factory ReceiptReviewEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;

  const factory ReceiptReviewEvent.categoriesChanged(
    List<Category> categories,
  ) = _CategoriesChanged;
}
