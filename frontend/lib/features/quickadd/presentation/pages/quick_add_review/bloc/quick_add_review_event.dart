part of 'quick_add_review_bloc.dart';

@freezed
sealed class QuickAddReviewEvent with _$QuickAddReviewEvent {
  const factory QuickAddReviewEvent.started() = _Started;

  const factory QuickAddReviewEvent.categoryPicked(String categoryId) =
      _CategoryPicked;

  const factory QuickAddReviewEvent.walletPicked(String walletId) =
      _WalletPicked;

  const factory QuickAddReviewEvent.toWalletPicked(String walletId) =
      _ToWalletPicked;

  const factory QuickAddReviewEvent.datePicked(DateTime date) = _DatePicked;
  const factory QuickAddReviewEvent.amountEdited(String text) = _AmountEdited;

  const factory QuickAddReviewEvent.noteEdited(String text) = _NoteEdited;

  const factory QuickAddReviewEvent.saveRequested({
    required String amount,
    required String note,
  }) = _SaveRequested;

  const factory QuickAddReviewEvent.skipRequested() = _SkipRequested;

  const factory QuickAddReviewEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;

  const factory QuickAddReviewEvent.categoriesChanged(
    List<Category> categories,
  ) = _CategoriesChanged;
}
