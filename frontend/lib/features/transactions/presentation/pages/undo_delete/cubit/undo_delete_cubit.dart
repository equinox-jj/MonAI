import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/watch_transaction_deletions_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/restore_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';

part 'undo_delete_cubit.freezed.dart';
part 'undo_delete_state.dart';

/// Offers to undo each transaction deleted anywhere in the app, for
/// [undoWindow]. One app-wide instance sits around the signed-in screens.
class UndoDeleteCubit extends Cubit<UndoDeleteState> {
  UndoDeleteCubit({
    required this._watchDeletions,
    required this._watchLookups,
    required this._restore,
  }) : super(const UndoDeleteState());

  /// How long the undo stays offered.
  static const undoWindow = Duration(seconds: 5);

  final WatchTransactionDeletionsUseCase _watchDeletions;
  final WatchTransactionLookupsUseCase _watchLookups;
  final RestoreTransactionUseCase _restore;

  StreamSubscription<void>? _deletions;
  StreamSubscription<void>? _lookups;

  /// Starts listening for deletes.
  void started() {
    _deletions ??= _watchDeletions(const NoParams())
        .listen((result) => result.match((_) {}, _offerUndo));
    _lookups ??= _watchLookups(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (lookups) => emit(state.copyWith(lookups: lookups)),
      ),
    );
  }

  void _offerUndo(Transaction deleted) =>
      emit(state.copyWith(deleted: deleted, restoreFailure: null));

  /// Restores the offered transaction.
  Future<void> undo() async {
    final deleted = state.deleted;
    if (deleted == null || state.isRestoring) return;
    emit(state.copyWith(deleted: null, isRestoring: true));
    final result = await _restore(deleted.id);
    switch (result) {
      case Right():
        emit(state.copyWith(isRestoring: false));
      case Left(value: final failure):
        emit(
          state.copyWith(
            isRestoring: false,
            restoreFailure: TransactionFailure.of(failure),
          ),
        );
        emit(state.copyWith(restoreFailure: null));
    }
  }

  /// The undo timed out or was swiped away.
  void dismissed() {
    if (state.deleted != null) emit(state.copyWith(deleted: null));
  }

  @override
  Future<void> close() async {
    await Future.wait([?_deletions?.cancel(), ?_lookups?.cancel()]);
    return super.close();
  }
}
