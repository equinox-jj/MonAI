part of 'transaction_detail_bloc.dart';

@freezed
sealed class TransactionDetailEvent with _$TransactionDetailEvent {
  /// The screen opened.
  const factory TransactionDetailEvent.started() = _Started;

  /// "Try again" on the error.
  const factory TransactionDetailEvent.retried() = _Retried;

  /// Deletes at once; the app shell offers the undo.
  const factory TransactionDetailEvent.deleteRequested() = _DeleteRequested;

  /// The cached transaction changed. Sent by the bloc itself.
  const factory TransactionDetailEvent.transactionChanged(
    Transaction? transaction,
  ) = _TransactionChanged;

  /// The cached categories or wallets changed. Sent by the bloc itself.
  const factory TransactionDetailEvent.lookupsChanged(
    TransactionLookups lookups,
  ) = _LookupsChanged;
}
