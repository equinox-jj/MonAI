part of 'quick_add_review_bloc.dart';

@freezed
sealed class QuickAddReviewEvent with _$QuickAddReviewEvent {
  /// The review opened.
  const factory QuickAddReviewEvent.started() = _Started;

  const factory QuickAddReviewEvent.categoryPicked(String categoryId) =
      _CategoryPicked;

  /// The wallet the money leaves (or, for income, arrives in).
  const factory QuickAddReviewEvent.walletPicked(String walletId) =
      _WalletPicked;

  /// A transfer's destination.
  const factory QuickAddReviewEvent.toWalletPicked(String walletId) =
      _ToWalletPicked;

  /// [date] is local midnight.
  const factory QuickAddReviewEvent.datePicked(DateTime date) = _DatePicked;

  /// The amount field changed to [text], e.g. `25.000`.
  const factory QuickAddReviewEvent.amountEdited(String text) = _AmountEdited;

  const factory QuickAddReviewEvent.noteEdited(String text) = _NoteEdited;

  /// Save this draft, with the text fields' text, then show the next.
  const factory QuickAddReviewEvent.saveRequested({
    required String amount,
    required String note,
  }) = _SaveRequested;

  /// Leave this draft unsaved and show the next.
  const factory QuickAddReviewEvent.skipRequested() = _SkipRequested;

  /// The cached active wallets changed. Sent by the bloc itself.
  const factory QuickAddReviewEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;

  /// The cached categories changed. Sent by the bloc itself.
  const factory QuickAddReviewEvent.categoriesChanged(
    List<Category> categories,
  ) = _CategoriesChanged;
}
