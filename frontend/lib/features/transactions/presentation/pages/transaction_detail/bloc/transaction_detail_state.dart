part of 'transaction_detail_bloc.dart';

@freezed
abstract class TransactionDetailState with _$TransactionDetailState {
  const factory TransactionDetailState({
    /// [UiStatus.loading] until the transaction is cached,
    /// [UiStatus.failure] when it couldn't be fetched or no longer exists,
    /// otherwise [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,
    Transaction? transaction,
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default(false) bool isRefreshing,
    @Default(false) bool isDeleting,

    /// The transaction was deleted, here or elsewhere: the screen closes.
    @Default(false) bool isClosed,

    /// Why the transaction couldn't be shown.
    TransactionFailure? loadFailure,

    /// Why a delete failed; shown once as a snackbar.
    TransactionFailure? actionFailure,
  }) = _TransactionDetailState;
}
