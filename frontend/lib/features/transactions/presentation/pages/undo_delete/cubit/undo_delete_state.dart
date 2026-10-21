part of 'undo_delete_cubit.dart';

@freezed
abstract class UndoDeleteState with _$UndoDeleteState {
  const factory UndoDeleteState({
    Transaction? deleted,
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default(false) bool isRestoring,
    TransactionFailure? restoreFailure,
  }) = _UndoDeleteState;
}
