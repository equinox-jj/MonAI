import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/ui/designsystem/components/monai_marked_field.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/quickadd/domain/usecase/save_quick_add_draft_usecase.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_field.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_save_failure.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

part 'quick_add_review_bloc.freezed.dart';
part 'quick_add_review_event.dart';
part 'quick_add_review_state.dart';

/// Steps through several quick-add drafts one at a time: each is checked,
/// then saved or skipped. Fields quick add filled are marked until the user
/// changes them. The amount and note live in the screen's text fields and
/// arrive with their edits and the save; input is checked on save, then
/// again on every change until it is valid.
class QuickAddReviewBloc
    extends Bloc<QuickAddReviewEvent, QuickAddReviewState> {
  /// [now] is the clock; tests pass a fixed one.
  QuickAddReviewBloc({
    required QuickAddReviewArgs args,
    required this._save,
    required this._watchWallets,
    required this._watchCategories,
    DateTime Function()? now,
  }) : super(_initialState(args, (now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_CategoryPicked>(_onCategoryPicked);
    on<_WalletPicked>(_onWalletPicked);
    on<_ToWalletPicked>(_onToWalletPicked);
    on<_DatePicked>(_onDatePicked);
    on<_AmountEdited>(_onAmountEdited);
    on<_NoteEdited>(_onNoteEdited);
    on<_SaveRequested>(_onSaveRequested);
    on<_SkipRequested>(_onSkipRequested);
    on<_WalletsChanged>(_onWalletsChanged);
    on<_CategoriesChanged>(_onCategoriesChanged);
  }

  final SaveQuickAddDraftUseCase _save;
  final WatchWalletsUseCase _watchWallets;
  final WatchCategoriesUseCase _watchCategories;

  StreamSubscription<void>? _wallets;
  StreamSubscription<void>? _categories;

  static QuickAddReviewState _initialState(
    QuickAddReviewArgs args,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    return _atDraft(
      QuickAddReviewState(args: args, today: today, current: args.drafts.first),
      0,
    );
  }

  /// [state] showing draft [index], or done past the last one.
  static QuickAddReviewState _atDraft(QuickAddReviewState state, int index) {
    if (index >= state.drafts.length) {
      return state.copyWith(index: index, marks: const {}, errors: const {});
    }
    final draft = state.drafts[index];
    final date = draft.date.isAfter(state.today) ? state.today : draft.date;
    return state.copyWith(
      index: index,
      current: draft.copyWith(date: date),
      marks: _marksOf(draft),
      errors: const {},
      autovalidate: false,
    );
  }

  /// A sparkle on what was read surely, a warning on the rest.
  static Map<QuickAddField, MonAIFieldMark> _marksOf(QuickAddDraft draft) {
    final confidence = draft.confidence;
    MonAIFieldMark of(double value) =>
        value >= DraftConfidence.sure ? .ai : .check;
    return {
      QuickAddField.amount: draft.amount == null
          ? .check
          : of(confidence.amount),
      if (draft.type != TransactionType.transfer)
        QuickAddField.category: draft.categoryId == null
            ? .check
            : of(confidence.category),
      QuickAddField.wallet: draft.walletId == null
          ? .check
          : of(confidence.wallet),
      QuickAddField.date: of(confidence.date),
    };
  }

  void _onStarted(_Started event, Emitter<QuickAddReviewState> emit) {
    _wallets = _watchWallets(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (wallets) => add(QuickAddReviewEvent.walletsChanged(wallets)),
      ),
    );
    _categories = _watchCategories(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (categories) => add(QuickAddReviewEvent.categoriesChanged(categories)),
      ),
    );
  }

  void _onWalletsChanged(
    _WalletsChanged event,
    Emitter<QuickAddReviewState> emit,
  ) => emit(state.copyWith(wallets: event.wallets));

  void _onCategoriesChanged(
    _CategoriesChanged event,
    Emitter<QuickAddReviewState> emit,
  ) => emit(state.copyWith(allCategories: event.categories));

  void _onCategoryPicked(
    _CategoryPicked event,
    Emitter<QuickAddReviewState> emit,
  ) => emit(
    _cleared(
      QuickAddField.category,
      state.copyWith(
        current: state.current.copyWith(categoryId: event.categoryId),
      ),
    ),
  );

  void _onWalletPicked(_WalletPicked event, Emitter<QuickAddReviewState> emit) {
    final current = state.current;
    // Picking the destination as the source swaps the two.
    final toWalletId = current.toWalletId == event.walletId
        ? current.walletId
        : current.toWalletId;
    emit(
      _cleared(
        QuickAddField.wallet,
        state.copyWith(
          current: current.copyWith(
            walletId: event.walletId,
            toWalletId: toWalletId,
          ),
        ),
      ),
    );
  }

  void _onToWalletPicked(
    _ToWalletPicked event,
    Emitter<QuickAddReviewState> emit,
  ) {
    final current = state.current;
    final walletId = current.walletId == event.walletId
        ? current.toWalletId
        : current.walletId;
    emit(
      _cleared(
        QuickAddField.toWallet,
        state.copyWith(
          current: current.copyWith(
            walletId: walletId,
            toWalletId: event.walletId,
          ),
        ),
      ),
    );
  }

  void _onDatePicked(_DatePicked event, Emitter<QuickAddReviewState> emit) {
    if (event.date.isAfter(state.today)) return;
    emit(
      _cleared(
        QuickAddField.date,
        state.copyWith(current: state.current.copyWith(date: event.date)),
      ),
    );
  }

  void _onAmountEdited(
    _AmountEdited event,
    Emitter<QuickAddReviewState> emit,
  ) =>
      _edited(emit, QuickAddField.amount, _input(amount: event.text, note: ''));

  void _onNoteEdited(_NoteEdited event, Emitter<QuickAddReviewState> emit) =>
      _edited(emit, QuickAddField.note, _input(amount: '', note: event.text));

  /// A typed field loses its mark; once a save failed on the input, its
  /// error is checked again with [input].
  void _edited(
    Emitter<QuickAddReviewState> emit,
    QuickAddField field,
    TransactionInput input,
  ) {
    final marks = {...state.marks}..remove(field);
    if (!state.autovalidate) {
      emit(state.copyWith(marks: marks));
      return;
    }
    final error = TransactionInputValidator.validate(
      input.normalized,
      today: state.today,
    ).where((e) => e.field == field.apiField).firstOrNull;
    final errors = {...state.errors}..remove(field.apiField);
    emit(
      state.copyWith(marks: marks, errors: {...errors, field.apiField: ?error}),
    );
  }

  /// [next] with [field]'s mark and error removed: the user chose it.
  QuickAddReviewState _cleared(QuickAddField field, QuickAddReviewState next) =>
      next.copyWith(
        marks: {...next.marks}..remove(field),
        errors: {...next.errors}..remove(field.apiField),
      );

  TransactionInput _input({required String amount, required String note}) {
    final current = state.current;
    final isTransfer = current.type == TransactionType.transfer;
    return TransactionInput(
      type: current.type,
      amount: parseRupiahInput(amount),
      date: current.date,
      walletId: current.walletId,
      toWalletId: isTransfer ? current.toWalletId : null,
      categoryId: isTransfer ? null : current.categoryId,
      note: note,
      merchant: current.merchant,
    );
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<QuickAddReviewState> emit,
  ) async {
    if (state.isSaving || state.isDone) return;
    emit(state.copyWith(isSaving: true));
    final result = await _save(_input(amount: event.amount, note: event.note));
    switch (result) {
      case Right(value: final transaction):
        _next(emit, QuickAddReviewResult.saved(transaction));
      case Left(value: ValidationFailure(:final fieldErrors)):
        emit(
          state.copyWith(
            isSaving: false,
            autovalidate: true,
            errors: {for (final error in fieldErrors) error.field: error},
          ),
        );
      case Left(value: final failure):
        emit(
          state.copyWith(
            isSaving: false,
            actionFailure: QuickAddSaveFailure.of(failure),
          ),
        );
        emit(state.copyWith(actionFailure: null));
    }
  }

  void _onSkipRequested(
    _SkipRequested event,
    Emitter<QuickAddReviewState> emit,
  ) {
    if (state.isSaving || state.isDone) return;
    _next(emit, const QuickAddReviewResult.skipped());
  }

  void _next(Emitter<QuickAddReviewState> emit, QuickAddReviewResult result) {
    emit(
      _atDraft(
        state.copyWith(isSaving: false, results: [...state.results, result]),
        state.index + 1,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _wallets?.cancel();
    await _categories?.cancel();
    return super.close();
  }
}
