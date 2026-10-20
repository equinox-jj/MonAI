part of 'undo_delete_cubit.dart';

@freezed
abstract class UndoDeleteState with _$UndoDeleteState {
  const factory UndoDeleteState({
    /// The transaction that can still be restored; null hides the undo.
    Transaction? deleted,

    /// Names for [deleted]'s title.
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default(false) bool isRestoring,

    /// Why the last restore failed; shown once.
    TransactionFailure? restoreFailure,
  }) = _UndoDeleteState;
}
