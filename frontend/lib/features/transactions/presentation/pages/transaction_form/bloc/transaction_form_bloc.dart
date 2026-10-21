import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/get_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/update_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_draft.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';

part 'transaction_form_bloc.freezed.dart';
part 'transaction_form_event.dart';
part 'transaction_form_state.dart';

/// The add and edit form. The note lives in the screen's text field and
/// arrives with save and close. Input is checked on save with the backend's
/// rules, then again on every change until it is valid.
class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  /// [now] is the clock; tests pass a fixed one.
  TransactionFormBloc({
    required TransactionFormMode mode,
    required this._getTransaction,
    required this._create,
    required this._update,
    required this._delete,
    required this._watchLookups,
    DateTime Function()? now,
  }) : _baselineNote = switch (mode) {
         PrefillTransactionMode(:final draft) => draft.note ?? '',
         _ => '',
       },
       super(_initialState(mode, (now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_Retried>(_onRetried);
    on<_TypeSelected>(_onTypeSelected);
    on<_DigitPressed>(_onDigitPressed);
    on<_TripleZeroPressed>(_onTripleZeroPressed);
    on<_BackspacePressed>(_onBackspacePressed);
    on<_CategoryPicked>(_onCategoryPicked);
    on<_WalletPicked>(_onWalletPicked);
    on<_ToWalletPicked>(_onToWalletPicked);
    on<_DatePicked>(_onDatePicked);
    on<_SaveRequested>(_onSaveRequested);
    on<_CloseRequested>(_onCloseRequested);
    on<_ScanRequested>(_onScanRequested);
    on<_DiscardConfirmed>(_onDiscardConfirmed);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_LookupsChanged>(_onLookupsChanged);
  }

  final GetTransactionUseCase _getTransaction;
  final CreateTransactionUseCase _create;
  final UpdateTransactionUseCase _update;
  final DeleteTransactionUseCase _delete;
  final WatchTransactionLookupsUseCase _watchLookups;

  StreamSubscription<void>? _lookups;

  /// The note the form started with: the edited transaction's own, or the
  /// quick-add draft's.
  String _baselineNote;

  /// Where the form goes once it is left: closed, or to the scanner.
  TransactionFormOutcome _leaveTo = const TransactionFormOutcome.closed();

  /// The fields only the device checks live; the note is checked on save.
  static const _liveFields = {
    TransactionInputValidator.amountField,
    TransactionInputValidator.walletField,
    TransactionInputValidator.toWalletField,
    TransactionInputValidator.categoryField,
    TransactionInputValidator.dateField,
  };

  static TransactionFormState _initialState(
    TransactionFormMode mode,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final draft = switch (mode) {
      AddTransactionMode(:final type, :final walletId) => TransactionDraft(
        type: type,
        date: today,
        walletId: walletId,
      ),
      PrefillTransactionMode(draft: final quick) => TransactionDraft(
        type: quick.type,
        // A draft read wrong as a later day starts at today.
        date: quick.date.isAfter(today) ? today : quick.date,
        amount: quick.amount ?? 0,
        walletId: quick.walletId,
        toWalletId: quick.toWalletId,
        categoryId: quick.categoryId,
      ),
      EditTransactionMode() => TransactionDraft(
        type: TransactionType.expense,
        date: today,
      ),
    };
    return TransactionFormState(
      mode: mode,
      today: today,
      draft: draft,
      baseline: draft,
      unsure: switch (mode) {
        PrefillTransactionMode(draft: final quick) => _unsureOf(quick),
        _ => const {},
      },
      status: mode is EditTransactionMode ? UiStatus.initial : UiStatus.success,
    );
  }

  /// The fields of [draft] the user should check: missing or read unsurely.
  static Set<String> _unsureOf(QuickAddDraft draft) => {
    if (draft.amount == null || draft.isAmountUnsure)
      TransactionInputValidator.amountField,
    if (draft.walletId == null || draft.isWalletUnsure)
      TransactionInputValidator.walletField,
    if (draft.isCategoryUnsure ||
        (draft.type != .transfer && draft.categoryId == null))
      TransactionInputValidator.categoryField,
    if (draft.isDateUnsure) TransactionInputValidator.dateField,
  };

  /// [unsure] without the fields [next] changed from [previous].
  static Set<String> _stillUnsure(
    Set<String> unsure,
    TransactionDraft previous,
    TransactionDraft next,
  ) {
    if (unsure.isEmpty) return unsure;
    return {
      for (final field in unsure)
        if (!switch (field) {
          TransactionInputValidator.amountField =>
            previous.amount != next.amount,
          TransactionInputValidator.walletField =>
            previous.walletId != next.walletId,
          TransactionInputValidator.categoryField =>
            previous.categoryId != next.categoryId,
          TransactionInputValidator.dateField => previous.date != next.date,
          _ => false,
        })
          field,
    };
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<TransactionFormState> emit,
  ) async {
    _lookups = _watchLookups(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (lookups) => add(TransactionFormEvent.lookupsChanged(lookups)),
      ),
    );
    await _load(emit);
  }

  Future<void> _onRetried(_Retried event, Emitter<TransactionFormState> emit) =>
      _load(emit);

  Future<void> _load(Emitter<TransactionFormState> emit) async {
    final mode = state.mode;
    if (mode is! EditTransactionMode) return;
    emit(state.copyWith(status: UiStatus.loading, loadFailure: null));
    final result = await _getTransaction(mode.id);
    switch (result) {
      case Right(value: final transaction):
        final draft = TransactionDraft(
          type: transaction.type,
          date: transaction.date,
          amount: transaction.amount,
          walletId: transaction.walletId,
          toWalletId: transaction.toWalletId,
          categoryId: transaction.categoryId,
        );
        _baselineNote = transaction.note ?? '';
        emit(
          state.copyWith(
            status: UiStatus.success,
            original: transaction,
            draft: draft,
            baseline: draft,
          ),
        );
      case Left(value: final failure):
        emit(
          state.copyWith(
            status: UiStatus.failure,
            loadFailure: TransactionFailure.of(failure),
          ),
        );
    }
  }

  void _onLookupsChanged(
    _LookupsChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(state.copyWith(lookups: event.lookups));
    if (state.mode is EditTransactionMode) return;
    // Defaults aren't changes: the baseline takes them too.
    final draft = _withDefaultWallets(state.draft);
    final baseline = _withDefaultWallets(state.baseline);
    if (draft != state.draft || baseline != state.baseline) {
      emit(state.copyWith(draft: draft, baseline: baseline));
    }
  }

  /// [draft] with the default wallet as its source when it has none, and a
  /// different wallet as a transfer's destination.
  TransactionDraft _withDefaultWallets(TransactionDraft draft) {
    final wallets = state.wallets;
    final source =
        draft.walletId ??
        (wallets.where((w) => w.isDefault).firstOrNull ?? wallets.firstOrNull)
            ?.id;
    return draft.copyWith(
      walletId: source,
      toWalletId: draft.type == .transfer
          ? draft.toWalletId ??
                wallets.where((w) => w.id != source).firstOrNull?.id
          : null,
    );
  }

  void _onTypeSelected(
    _TypeSelected event,
    Emitter<TransactionFormState> emit,
  ) {
    final type = event.type;
    if (type == state.draft.type) return;
    final withType = state.draft.copyWith(type: type);
    final category = state.lookups.category(state.draft.categoryId);
    final keepsCategory = switch ((type, category?.type)) {
      (.expense, CategoryType.expense) ||
      (.income, CategoryType.income) => true,
      _ => false,
    };
    _edit(
      emit,
      _withDefaultWallets(
        withType.copyWith(
          categoryId: keepsCategory ? state.draft.categoryId : null,
        ),
      ),
    );
  }

  void _onDigitPressed(
    _DigitPressed event,
    Emitter<TransactionFormState> emit,
  ) => _editAmount(emit, state.draft.amount * 10 + event.digit);

  void _onTripleZeroPressed(
    _TripleZeroPressed event,
    Emitter<TransactionFormState> emit,
  ) => _editAmount(emit, state.draft.amount * 1000);

  void _onBackspacePressed(
    _BackspacePressed event,
    Emitter<TransactionFormState> emit,
  ) => _editAmount(emit, state.draft.amount ~/ 10);

  /// Keys that would pass the server's limit do nothing.
  void _editAmount(Emitter<TransactionFormState> emit, int amount) {
    if (amount > TransactionInputValidator.amountMax) return;
    _edit(emit, state.draft.copyWith(amount: amount));
  }

  void _onCategoryPicked(
    _CategoryPicked event,
    Emitter<TransactionFormState> emit,
  ) => _edit(emit, state.draft.copyWith(categoryId: event.categoryId));

  void _onWalletPicked(
    _WalletPicked event,
    Emitter<TransactionFormState> emit,
  ) {
    final draft = state.draft;
    // Picking the destination as the source swaps the two.
    final toWalletId = draft.toWalletId == event.walletId
        ? draft.walletId
        : draft.toWalletId;
    _edit(
      emit,
      draft.copyWith(walletId: event.walletId, toWalletId: toWalletId),
    );
  }

  void _onToWalletPicked(
    _ToWalletPicked event,
    Emitter<TransactionFormState> emit,
  ) {
    final draft = state.draft;
    final walletId = draft.walletId == event.walletId
        ? draft.toWalletId
        : draft.walletId;
    _edit(emit, draft.copyWith(walletId: walletId, toWalletId: event.walletId));
  }

  void _onDatePicked(_DatePicked event, Emitter<TransactionFormState> emit) {
    final date = event.date;
    if (date.isAfter(state.today)) return;
    _edit(emit, state.draft.copyWith(date: date));
  }

  /// Applies an edit, re-checking the fields once a save failed on them.
  void _edit(Emitter<TransactionFormState> emit, TransactionDraft draft) {
    final unsure = _stillUnsure(state.unsure, state.draft, draft);
    if (!state.autovalidate) {
      emit(state.copyWith(draft: draft, unsure: unsure));
      return;
    }
    final live = TransactionInputValidator.validate(
      _input(draft, note: '').normalized,
      today: state.today,
    ).where((error) => _liveFields.contains(error.field));
    emit(
      state.copyWith(
        draft: draft,
        unsure: unsure,
        errors: {
          // The note is only checked on save.
          for (final MapEntry(:key, :value) in state.errors.entries)
            if (!_liveFields.contains(key)) key: value,
          for (final error in live) error.field: error,
        },
      ),
    );
  }

  TransactionInput _input(TransactionDraft draft, {required String note}) {
    final quick = switch (state.mode) {
      PrefillTransactionMode(:final draft) => draft,
      _ => null,
    };
    return TransactionInput(
      type: draft.type,
      amount: draft.amount,
      date: draft.date,
      walletId: draft.walletId,
      toWalletId: draft.toWalletId,
      categoryId: draft.categoryId,
      note: note,
      // The form doesn't edit these; an update keeps them.
      merchant: state.original?.merchant ?? quick?.merchant,
      source: state.original?.source ?? (quick != null ? .quickAdd : .manual),
    );
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<TransactionFormState> emit,
  ) async {
    if (state.isSaving || state.status != UiStatus.success) return;
    emit(state.copyWith(isSaving: true));
    final input = _input(state.draft, note: event.note);
    final original = state.original;
    final result = original == null
        ? await _create(input)
        : await _update(
            UpdateTransactionParams(original: original, input: input),
          );
    switch (result) {
      case Right(value: final saved):
        emit(
          state.copyWith(
            isSaving: false,
            outcome: TransactionFormOutcome.saved(saved.id),
          ),
        );
      case Left(value: ValidationFailure(:final fieldErrors)):
        emit(
          state.copyWith(
            isSaving: false,
            autovalidate: true,
            errors: {for (final error in fieldErrors) error.field: error},
          ),
        );
      case Left(value: final failure):
        _fail(emit, failure, isSaving: false);
    }
  }

  void _onCloseRequested(
    _CloseRequested event,
    Emitter<TransactionFormState> emit,
  ) => _leave(emit, const TransactionFormOutcome.closed(), note: event.note);

  void _onScanRequested(
    _ScanRequested event,
    Emitter<TransactionFormState> emit,
  ) {
    if (state.mode is! AddTransactionMode) return;
    _leave(emit, const TransactionFormOutcome.scanReceipt(), note: event.note);
  }

  /// Leaves for [outcome], asking first when something changed.
  void _leave(
    Emitter<TransactionFormState> emit,
    TransactionFormOutcome outcome, {
    required String note,
  }) {
    _leaveTo = outcome;
    final changed =
        state.status == UiStatus.success &&
        (state.draft != state.baseline || note.trim() != _baselineNote);
    if (changed) {
      emit(state.copyWith(askDiscard: true));
      emit(state.copyWith(askDiscard: false));
    } else {
      emit(state.copyWith(outcome: outcome));
    }
  }

  void _onDiscardConfirmed(
    _DiscardConfirmed event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(state.copyWith(outcome: _leaveTo));
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<TransactionFormState> emit,
  ) async {
    final original = state.original;
    if (original == null || state.isDeleting) return;
    emit(state.copyWith(isDeleting: true));
    final result = await _delete(original.id);
    switch (result) {
      case Right():
        emit(
          state.copyWith(
            isDeleting: false,
            outcome: TransactionFormOutcome.deleted(original.id),
          ),
        );
      case Left(value: final failure):
        _fail(emit, failure, isDeleting: false);
    }
  }

  /// Reports [failure] once and ends the save or delete.
  void _fail(
    Emitter<TransactionFormState> emit,
    Failure failure, {
    bool? isSaving,
    bool? isDeleting,
  }) {
    emit(
      state.copyWith(
        isSaving: isSaving ?? state.isSaving,
        isDeleting: isDeleting ?? state.isDeleting,
        actionFailure: TransactionFailure.of(failure),
      ),
    );
    emit(state.copyWith(actionFailure: null));
  }

  @override
  Future<void> close() async {
    await _lookups?.cancel();
    return super.close();
  }
}
