part of 'transaction_detail_bloc.dart';

@freezed
sealed class TransactionDetailEvent with _$TransactionDetailEvent {
  const factory TransactionDetailEvent.started() = _Started;
  const factory TransactionDetailEvent.retried() = _Retried;
  const factory TransactionDetailEvent.deleteRequested() = _DeleteRequested;

  const factory TransactionDetailEvent.transactionChanged(
    Transaction? transaction,
  ) = _TransactionChanged;

  const factory TransactionDetailEvent.lookupsChanged(
    TransactionLookups lookups,
  ) = _LookupsChanged;
}
