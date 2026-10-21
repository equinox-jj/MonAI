part of 'transaction_form_bloc.dart';

@freezed
sealed class TransactionFormEvent with _$TransactionFormEvent {
  const factory TransactionFormEvent.started() = _Started;
  const factory TransactionFormEvent.retried() = _Retried;

  const factory TransactionFormEvent.typeSelected(TransactionType type) =
      _TypeSelected;

  const factory TransactionFormEvent.digitPressed(int digit) = _DigitPressed;
  const factory TransactionFormEvent.tripleZeroPressed() = _TripleZeroPressed;

  const factory TransactionFormEvent.backspacePressed() = _BackspacePressed;

  const factory TransactionFormEvent.categoryPicked(String categoryId) =
      _CategoryPicked;

  const factory TransactionFormEvent.walletPicked(String walletId) =
      _WalletPicked;

  const factory TransactionFormEvent.toWalletPicked(String walletId) =
      _ToWalletPicked;

  const factory TransactionFormEvent.datePicked(DateTime date) = _DatePicked;

  const factory TransactionFormEvent.saveRequested({required String note}) =
      _SaveRequested;

  const factory TransactionFormEvent.closeRequested({required String note}) =
      _CloseRequested;

  const factory TransactionFormEvent.scanRequested({required String note}) =
      _ScanRequested;

  const factory TransactionFormEvent.discardConfirmed() = _DiscardConfirmed;
  const factory TransactionFormEvent.deleteRequested() = _DeleteRequested;

  const factory TransactionFormEvent.lookupsChanged(
    TransactionLookups lookups,
  ) = _LookupsChanged;
}
