part of 'transaction_detail_bloc.dart';

@freezed
abstract class TransactionDetailState with _$TransactionDetailState {
  const factory TransactionDetailState({
    @Default(UiStatus.initial) UiStatus status,
    Transaction? transaction,
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default(false) bool isRefreshing,
    @Default(false) bool isDeleting,
    @Default(false) bool isClosed,
    TransactionFailure? loadFailure,
    TransactionFailure? actionFailure,
  }) = _TransactionDetailState;
}
