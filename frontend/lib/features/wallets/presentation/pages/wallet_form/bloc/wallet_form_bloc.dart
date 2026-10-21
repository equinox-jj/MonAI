import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/shared/domain/usecase/refresh_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/logic/wallet_form_rules.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/create_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/delete_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/update_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';

part 'wallet_form_bloc.freezed.dart';
part 'wallet_form_event.dart';
part 'wallet_form_state.dart';

class WalletFormBloc extends Bloc<WalletFormEvent, WalletFormState> {
  WalletFormBloc({
    required WalletFormMode mode,
    required this._watchProviders,
    required this._refreshProviders,
    required this._watchWallet,
    required this._watchWallets,
    required this._create,
    required this._update,
    required this._archive,
    required this._delete,
  }) : super(
         WalletFormState(
           mode: mode,
           status: mode is AddWalletMode ? UiStatus.success : UiStatus.initial,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_Retried>(_onRetried);
    on<_ProviderPicked>(_onProviderPicked);
    on<_TypePicked>(_onTypePicked);
    on<_ColorPicked>(_onColorPicked);
    on<_DefaultToggled>(_onDefaultToggled);
    on<_NameEdited>(_onNameEdited);
    on<_BalanceEdited>(_onBalanceEdited);
    on<_SaveRequested>(_onSaveRequested);
    on<_ArchiveRequested>(_onArchiveRequested);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_ProvidersChanged>(_onProvidersChanged);
    on<_WalletsChanged>(_onWalletsChanged);
  }

  final WatchPaymentProvidersUseCase _watchProviders;
  final RefreshPaymentProvidersUseCase _refreshProviders;
  final WatchWalletUseCase _watchWallet;
  final WatchWalletsUseCase _watchWallets;
  final CreateWalletUseCase _create;
  final UpdateWalletUseCase _update;
  final ArchiveWalletUseCase _archive;
  final DeleteWalletUseCase _delete;

  StreamSubscription<void>? _providers;
  StreamSubscription<void>? _wallets;

  String _lastName = '';

  Future<void> _onStarted(_Started event, Emitter<WalletFormState> emit) async {
    _wallets = _watchWallets(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (wallets) => add(WalletFormEvent.walletsChanged(wallets)),
      ),
    );
    if (state.mode is AddWalletMode) {
      _providers = _watchProviders(const NoParams()).listen(
        (result) => result.match(
          (_) {},
          (providers) => add(WalletFormEvent.providersChanged(providers)),
        ),
      );
      // Best effort: the cached or bundled catalog stays on failure.
      await _refreshProviders(const NoParams());
      return;
    }
    await _load(emit);
  }

  Future<void> _onRetried(_Retried event, Emitter<WalletFormState> emit) =>
      _load(emit);

  Future<void> _load(Emitter<WalletFormState> emit) async {
    final mode = state.mode;
    if (mode is! EditWalletMode) return;
    emit(state.copyWith(status: UiStatus.loading, loadFailure: null));
    final result = await _watchWallet(mode.id).first;
    switch (result) {
      case Right(value: final wallet?):
        emit(
          state.copyWith(
            status: UiStatus.success,
            original: wallet,
            type: wallet.type,
            color: wallet.color,
            isDefault: wallet.isDefault,
            initialBalance: wallet.initialBalance,
          ),
        );
      case Right(value: null):
        emit(
          state.copyWith(
            status: UiStatus.failure,
            loadFailure: WalletFailure.notFound,
          ),
        );
      case Left(value: final failure):
        emit(
          state.copyWith(
            status: UiStatus.failure,
            loadFailure: WalletFailure.of(failure),
          ),
        );
    }
  }

  void _onProvidersChanged(
    _ProvidersChanged event,
    Emitter<WalletFormState> emit,
  ) {
    emit(state.copyWith(providers: event.providers));
  }

  void _onWalletsChanged(_WalletsChanged event, Emitter<WalletFormState> emit) {
    emit(
      state.copyWith(
        defaultWalletName: event.wallets
            .where((w) => w.isDefault)
            .firstOrNull
            ?.name,
      ),
    );
  }

  void _onProviderPicked(_ProviderPicked event, Emitter<WalletFormState> emit) {
    final slug = event.slug;
    if (slug == state.providerSlug) return;
    final provider = state.providers.where((p) => p.slug == slug).firstOrNull;
    emit(
      state.copyWith(
        providerSlug: slug,
        type: provider?.type,
        nameFill: provider?.name ?? '',
      ),
    );
    emit(state.copyWith(nameFill: null));
    _recheck(emit, {
      WalletInputValidator.nameField: provider?.name ?? '',
      WalletInputValidator.typeField: null,
    });
  }

  void _onTypePicked(_TypePicked event, Emitter<WalletFormState> emit) {
    if (state.isTypeLocked) return;
    emit(state.copyWith(type: event.type));
    _recheck(emit, {WalletInputValidator.typeField: null});
  }

  void _onColorPicked(_ColorPicked event, Emitter<WalletFormState> emit) {
    emit(state.copyWith(color: event.hex));
  }

  void _onDefaultToggled(_DefaultToggled event, Emitter<WalletFormState> emit) {
    // The default can only move to another wallet, never be unset here.
    if (state.original?.isDefault ?? false) return;
    emit(state.copyWith(isDefault: event.isDefault));
  }

  void _onNameEdited(_NameEdited event, Emitter<WalletFormState> emit) =>
      _recheck(emit, {WalletInputValidator.nameField: event.name});

  void _onBalanceEdited(_BalanceEdited event, Emitter<WalletFormState> emit) {
    emit(state.copyWith(initialBalance: parseRupiahInput(event.balance)));
    _recheck(emit, {WalletInputValidator.initialBalanceField: null});
  }

  void _recheck(Emitter<WalletFormState> emit, Map<String, String?> edited) {
    if (!state.autovalidate) return;
    final name = edited[WalletInputValidator.nameField] ?? _lastName;
    if (edited.containsKey(WalletInputValidator.nameField)) _lastName = name;
    final found = {
      for (final error in WalletInputValidator.validate(
        _input(name: name, initialBalance: state.initialBalance).normalized,
      ))
        error.field: error,
    };
    emit(
      state.copyWith(
        errors: {
          for (final MapEntry(:key, :value) in state.errors.entries)
            if (!edited.containsKey(key)) key: value,
          for (final field in edited.keys) field: ?found[field],
        },
      ),
    );
  }

  WalletInput _input({required String name, required int initialBalance}) =>
      switch (state.original) {
        final wallet? => editedWalletInput(
          wallet,
          name: name,
          initialBalance: initialBalance,
          color: state.color,
          isDefault: state.isDefault,
        ),
        null => newWalletInput(
          provider: state.selectedProvider,
          name: name,
          type: state.type,
          initialBalance: initialBalance,
          isDefault: state.isDefault,
        ),
      };

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<WalletFormState> emit,
  ) async {
    if (state.isBusy || state.status != UiStatus.success) return;
    _lastName = event.name;
    final initialBalance = parseRupiahInput(event.balance);
    emit(state.copyWith(isSaving: true, initialBalance: initialBalance));
    final input = _input(name: event.name, initialBalance: initialBalance);
    final original = state.original;
    final result = original == null
        ? await _create(input)
        : await _update(UpdateWalletParams(wallet: original, input: input));
    switch (result) {
      case Right(value: final saved):
        emit(
          state.copyWith(
            isSaving: false,
            outcome: WalletFormOutcome.saved(saved.id),
          ),
        );
      case Left(value: ValidationFailure(:final fieldErrors))
          when fieldErrors.isNotEmpty:
        _showErrors(emit, fieldErrors);
      case Left(value: ConflictFailure(:final message)):
        _showErrors(emit, [
          FieldError(
            field: WalletInputValidator.nameField,
            code: 'conflict',
            message: message,
          ),
        ]);
      case Left(value: final failure):
        _fail(emit, failure, isSaving: false);
    }
  }

  void _showErrors(Emitter<WalletFormState> emit, List<FieldError> errors) {
    emit(
      state.copyWith(
        isSaving: false,
        autovalidate: true,
        errors: {for (final error in errors) error.field: error},
      ),
    );
  }

  Future<void> _onArchiveRequested(
    _ArchiveRequested event,
    Emitter<WalletFormState> emit,
  ) async {
    final original = state.original;
    if (original == null || state.isBusy) return;
    emit(state.copyWith(isArchiving: true));
    final result = await _archive(original);
    switch (result) {
      case Right():
        emit(
          state.copyWith(
            isArchiving: false,
            outcome: WalletFormOutcome.archived(original.name),
          ),
        );
      case Left(value: final failure):
        _fail(emit, failure, isArchiving: false);
    }
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<WalletFormState> emit,
  ) async {
    final original = state.original;
    if (original == null || state.isBusy) return;
    emit(state.copyWith(isDeleting: true));
    final result = await _delete(original);
    switch (result) {
      case Right():
        emit(
          state.copyWith(
            isDeleting: false,
            outcome: WalletFormOutcome.deleted(original.name),
          ),
        );
      case Left(value: final failure)
          when WalletFailure.of(failure) == .hasTransactions:
        emit(state.copyWith(isDeleting: false, offerArchive: true));
        emit(state.copyWith(offerArchive: false));
      case Left(value: final failure):
        _fail(emit, failure, isDeleting: false);
    }
  }

  void _fail(
    Emitter<WalletFormState> emit,
    Failure failure, {
    bool? isSaving,
    bool? isArchiving,
    bool? isDeleting,
  }) {
    emit(
      state.copyWith(
        isSaving: isSaving ?? state.isSaving,
        isArchiving: isArchiving ?? state.isArchiving,
        isDeleting: isDeleting ?? state.isDeleting,
        actionFailure: WalletFailure.of(failure),
      ),
    );
    emit(state.copyWith(actionFailure: null));
  }

  @override
  Future<void> close() async {
    await Future.wait([?_providers?.cancel(), ?_wallets?.cancel()]);
    return super.close();
  }
}
