part of 'transaction_form_bloc.dart';

@freezed
sealed class TransactionFormEvent with _$TransactionFormEvent {
  /// The form opened.
  const factory TransactionFormEvent.started() = _Started;

  /// "Try again" when the edited transaction couldn't be loaded.
  const factory TransactionFormEvent.retried() = _Retried;

  const factory TransactionFormEvent.typeSelected(TransactionType type) =
      _TypeSelected;

  /// A keypad digit, 0 to 9.
  const factory TransactionFormEvent.digitPressed(int digit) = _DigitPressed;

  /// The keypad's "000" key.
  const factory TransactionFormEvent.tripleZeroPressed() = _TripleZeroPressed;

  const factory TransactionFormEvent.backspacePressed() = _BackspacePressed;

  const factory TransactionFormEvent.categoryPicked(String categoryId) =
      _CategoryPicked;

  /// The wallet the money leaves (or, for income, arrives in).
  const factory TransactionFormEvent.walletPicked(String walletId) =
      _WalletPicked;

  /// A transfer's destination.
  const factory TransactionFormEvent.toWalletPicked(String walletId) =
      _ToWalletPicked;

  /// [date] is local midnight.
  const factory TransactionFormEvent.datePicked(DateTime date) = _DatePicked;

  /// Save, with the note field's text.
  const factory TransactionFormEvent.saveRequested({required String note}) =
      _SaveRequested;

  /// Close or back, with the note field's text: asks first when something
  /// changed.
  const factory TransactionFormEvent.closeRequested({required String note}) =
      _CloseRequested;

  /// The Scan chip, with the note field's text: like close, then the
  /// receipt scanner. Adding only.
  const factory TransactionFormEvent.scanRequested({required String note}) =
      _ScanRequested;

  /// "Discard" in the discard dialog.
  const factory TransactionFormEvent.discardConfirmed() = _DiscardConfirmed;

  /// Editing only; the app shell offers the undo.
  const factory TransactionFormEvent.deleteRequested() = _DeleteRequested;

  /// The cached categories or wallets changed. Sent by the bloc itself.
  const factory TransactionFormEvent.lookupsChanged(
    TransactionLookups lookups,
  ) = _LookupsChanged;
}
