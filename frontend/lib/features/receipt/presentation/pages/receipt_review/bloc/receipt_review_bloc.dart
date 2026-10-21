import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/usecase/create_receipt_transaction_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_field.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

part 'receipt_review_bloc.freezed.dart';
part 'receipt_review_event.dart';
part 'receipt_review_state.dart';

class ReceiptReviewBloc extends Bloc<ReceiptReviewEvent, ReceiptReviewState> {
  ReceiptReviewBloc({
    required ReceiptReviewArgs args,
    required this._save,
    required this._parse,
    required this._watchWallets,
    required this._watchCategories,
    DateTime Function()? now,
  }) : super(_initialState(args, (now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_TypeSelected>(_onTypeSelected);
    on<_CategoryPicked>(_onCategoryPicked);
    on<_WalletPicked>(_onWalletPicked);
    on<_DatePicked>(_onDatePicked);
    on<_AmountEdited>(_onAmountEdited);
    on<_MerchantEdited>(_onMerchantEdited);
    on<_NoteEdited>(_onNoteEdited);
    on<_SaveRequested>(_onSaveRequested);
    on<_RetryRequested>(_onRetryRequested);
    on<_WalletsChanged>(_onWalletsChanged);
    on<_CategoriesChanged>(_onCategoriesChanged);
  }

  final CreateReceiptTransactionUseCase _save;
  final ParseReceiptUseCase _parse;
  final WatchWalletsUseCase _watchWallets;
  final WatchCategoriesUseCase _watchCategories;

  StreamSubscription<void>? _wallets;
  StreamSubscription<void>? _categories;

  static ReceiptReviewState _initialState(
    ReceiptReviewArgs args,
    DateTime now,
  ) {
    final initial = ReceiptReviewState(
      args: args,
      today: DateTime(now.year, now.month, now.day),
      draft: args.draft,
      type: TransactionType.expense,
      date: now,
    );
    return _withDraft(initial, args.draft, aiFailure: args.aiFailure);
  }

  /// [state] filled from [draft]: an income stays one and anything else is
  /// an expense; a missing date, or one after today (read wrong), is today.
  /// Without a wallet the current one stays (the default, once loaded).
  static ReceiptReviewState _withDraft(
    ReceiptReviewState state,
    ReceiptDraft draft, {
    ReceiptAiFailure? aiFailure,
  }) {
    final today = state.today;
    final read = draft.date;
    final inFuture = read != null && read.isAfter(today);
    return state.copyWith(
      draft: draft,
      aiFailure: aiFailure,
      type: draft.type == TransactionType.income
          ? TransactionType.income
          : TransactionType.expense,
      date: read == null || inFuture ? today : read,
      walletId: draft.walletId ?? state.walletId,
      categoryId: draft.categoryId,
      marks: aiFailure != null
          ? const {}
          : _marksOf(draft, dateInFuture: inFuture),
      errors: const {},
      autovalidate: false,
    );
  }

  /// A date after today was read wrong, so it became today and needs checking.
  static Map<ReceiptField, FieldMark> _marksOf(
    ReceiptDraft draft, {
    required bool dateInFuture,
  }) {
    final confidence = draft.confidence;
    FieldMark of(double value) =>
        value >= DraftConfidence.sure ? FieldMark.ai : FieldMark.check;
    return {
      if (draft.amount != null) ReceiptField.amount: of(confidence.amount),
      if (draft.merchant?.trim().isNotEmpty ?? false)
        ReceiptField.merchant: FieldMark.ai,
      if (draft.categoryId != null)
        ReceiptField.category: of(confidence.category),
      if (draft.walletId != null) ReceiptField.wallet: of(confidence.wallet),
      if (draft.date != null)
        ReceiptField.date: dateInFuture ? FieldMark.check : of(confidence.date),
    };
  }

  void _onStarted(_Started event, Emitter<ReceiptReviewState> emit) {
    _wallets = _watchWallets(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (wallets) => add(ReceiptReviewEvent.walletsChanged(wallets)),
      ),
    );
    _categories = _watchCategories(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (categories) => add(ReceiptReviewEvent.categoriesChanged(categories)),
      ),
    );
  }

  void _onWalletsChanged(
    _WalletsChanged event,
    Emitter<ReceiptReviewState> emit,
  ) {
    final wallets = event.wallets;
    // A receipt rarely names the wallet: the default one is used then.
    final walletId =
        state.walletId ??
        (wallets.where((w) => w.isDefault).firstOrNull ?? wallets.firstOrNull)
            ?.id;
    emit(state.copyWith(wallets: wallets, walletId: walletId));
  }

  void _onCategoriesChanged(
    _CategoriesChanged event,
    Emitter<ReceiptReviewState> emit,
  ) => emit(state.copyWith(allCategories: event.categories));

  void _onTypeSelected(_TypeSelected event, Emitter<ReceiptReviewState> emit) {
    final type = event.type;
    // A receipt is an expense or an income, never a transfer.
    if (type == TransactionType.transfer || type == state.type) return;
    // Categories belong to one type, so the old one can't stay.
    emit(
      _cleared(
        ReceiptField.category,
        state.copyWith(type: type, categoryId: null),
      ),
    );
  }

  void _onCategoryPicked(
    _CategoryPicked event,
    Emitter<ReceiptReviewState> emit,
  ) => emit(
    _cleared(
      ReceiptField.category,
      state.copyWith(categoryId: event.categoryId),
    ),
  );

  void _onWalletPicked(_WalletPicked event, Emitter<ReceiptReviewState> emit) =>
      emit(
        _cleared(ReceiptField.wallet, state.copyWith(walletId: event.walletId)),
      );

  void _onDatePicked(_DatePicked event, Emitter<ReceiptReviewState> emit) {
    if (event.date.isAfter(state.today)) return;
    emit(_cleared(ReceiptField.date, state.copyWith(date: event.date)));
  }

  void _onAmountEdited(_AmountEdited event, Emitter<ReceiptReviewState> emit) =>
      _edited(
        emit,
        ReceiptField.amount,
        _input(amount: event.text, merchant: '', note: ''),
      );

  void _onMerchantEdited(
    _MerchantEdited event,
    Emitter<ReceiptReviewState> emit,
  ) => _edited(
    emit,
    ReceiptField.merchant,
    _input(amount: '', merchant: event.text, note: ''),
  );

  void _onNoteEdited(_NoteEdited event, Emitter<ReceiptReviewState> emit) =>
      _edited(
        emit,
        ReceiptField.note,
        _input(amount: '', merchant: '', note: event.text),
      );

  void _edited(
    Emitter<ReceiptReviewState> emit,
    ReceiptField field,
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

  ReceiptReviewState _cleared(ReceiptField field, ReceiptReviewState next) =>
      next.copyWith(
        marks: {...next.marks}..remove(field),
        errors: {...next.errors}..remove(field.apiField),
      );

  TransactionInput _input({
    required String amount,
    required String merchant,
    required String note,
  }) => TransactionInput(
    type: state.type,
    amount: parseRupiahInput(amount),
    date: state.date,
    walletId: state.walletId,
    categoryId: state.categoryId,
    merchant: merchant,
    note: note,
    source: TransactionSource.receipt,
  );

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<ReceiptReviewState> emit,
  ) async {
    if (state.isSaving || state.savedId != null) return;
    emit(state.copyWith(isSaving: true));
    final result = await _save(
      CreateReceiptTransactionParams(
        input: _input(
          amount: event.amount,
          merchant: event.merchant,
          note: event.note,
        ),
        photoPath: state.args.photoPath,
      ),
    );
    switch (result) {
      case Right(value: final transaction):
        emit(state.copyWith(isSaving: false, savedId: transaction.id));
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
            actionFailure: ReceiptFailure.of(failure),
          ),
        );
        emit(state.copyWith(actionFailure: null));
    }
  }

  Future<void> _onRetryRequested(
    _RetryRequested event,
    Emitter<ReceiptReviewState> emit,
  ) async {
    if (state.aiFailure == null || state.isRetrying || state.isSaving) return;
    emit(state.copyWith(isRetrying: true));
    final result = await _parse(state.args.ocrText);
    switch (result) {
      case Right(value: final draft):
        emit(
          _withDraft(
            state,
            draft,
          ).copyWith(isRetrying: false, draftVersion: state.draftVersion + 1),
        );
      case Left(value: final failure):
        final aiFailure = ReceiptAiFailure.of(failure);
        emit(
          state.copyWith(
            isRetrying: false,
            aiFailure: aiFailure,
            retryFailure: aiFailure,
          ),
        );
        emit(state.copyWith(retryFailure: null));
    }
  }

  @override
  Future<void> close() async {
    await _wallets?.cancel();
    await _categories?.cancel();
    return super.close();
  }
}
