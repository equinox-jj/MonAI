import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/data/services/avatar_photo_service.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/domain/usecase/create_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/delete_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_provider_active_usecase.dart';
import 'package:monai/features/settings/domain/usecase/update_provider_usecase.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

part 'provider_form_bloc.freezed.dart';
part 'provider_form_event.dart';
part 'provider_form_state.dart';

/// Adds a provider, or edits the one with the given id: name, type, aliases,
/// sort order, status and logo. On an existing provider, the status switch
/// and Delete apply at once, after a confirmation; everything else waits for
/// Save. The name, the alias being typed and the sort order live in the
/// screen's text fields and arrive with each edit and with Save.
class ProviderFormBloc extends Bloc<ProviderFormEvent, ProviderFormState> {
  ProviderFormBloc({
    required String? providerId,
    required this._watchUser,
    required this._getProvider,
    required this._create,
    required this._update,
    required this._setActive,
    required this._delete,
    required this._photos,
  }) : _providerId = providerId,
       super(
         ProviderFormState(
           isNew: providerId == null,
           status: providerId == null ? .success : .initial,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_UserChanged>(_onUserChanged);
    on<_Retried>(_onRetried);
    on<_NameEdited>(_onNameEdited);
    on<_SortOrderEdited>(_onSortOrderEdited);
    on<_TypePicked>(_onTypePicked);
    on<_AliasTyped>(_onAliasTyped);
    on<_AliasSubmitted>(_onAliasSubmitted);
    on<_AliasRemoved>(_onAliasRemoved);
    on<_ActiveToggled>(_onActiveToggled);
    on<_LogoPickRequested>(_onLogoPickRequested);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_DialogConfirmed>(_onDialogConfirmed);
    on<_DialogDismissed>(_onDialogDismissed);
    on<_SaveRequested>(_onSaveRequested);
  }

  final String? _providerId;
  final WatchUserUseCase _watchUser;
  final GetAdminProviderUseCase _getProvider;
  final CreateProviderUseCase _create;
  final UpdateProviderUseCase _update;
  final SetProviderActiveUseCase _setActive;
  final DeleteProviderUseCase _delete;
  final AvatarPhotoService _photos;

  StreamSubscription<void>? _user;
  User? _currentUser;

  Future<void> _onStarted(
    _Started event,
    Emitter<ProviderFormState> emit,
  ) async {
    unawaited(_user?.cancel());
    _user = _watchUser(const NoParams()).listen(
      // A failed cache read keeps the last permissions.
      (result) => result.match(
        (_) {},
        (user) => add(ProviderFormEvent.userChanged(user)),
      ),
    );
    await _load(emit);
  }

  Future<void> _onRetried(_Retried event, Emitter<ProviderFormState> emit) =>
      _load(emit);

  Future<void> _load(Emitter<ProviderFormState> emit) async {
    final id = _providerId;
    if (id == null) return;
    emit(state.copyWith(status: .loading, loadFailure: null));
    final result = await _getProvider(id);
    emit(
      result.match(
        (failure) => state.copyWith(
          status: .failure,
          loadFailure: ProviderFailure.of(failure),
        ),
        (provider) => _filledFrom(state, provider),
      ),
    );
  }

  void _onUserChanged(_UserChanged event, Emitter<ProviderFormState> emit) {
    _currentUser = event.user;
    emit(_withPermissions(state));
  }

  void _onNameEdited(_NameEdited event, Emitter<ProviderFormState> emit) {
    emit(
      state.copyWith(
        hasName: event.name.trim().isNotEmpty,
        slug: providerSlugPreview(state.original, event.name),
        nameError: null,
      ),
    );
  }

  void _onSortOrderEdited(
    _SortOrderEdited event,
    Emitter<ProviderFormState> emit,
  ) {
    emit(state.copyWith(sortOrderValid: int.tryParse(event.text) != null));
  }

  void _onTypePicked(_TypePicked event, Emitter<ProviderFormState> emit) {
    emit(state.copyWith(type: event.type));
  }

  /// Typing a comma adds what came before it, like Enter.
  void _onAliasTyped(_AliasTyped event, Emitter<ProviderFormState> emit) {
    emit(
      event.text.contains(',')
          ? _withAliases(state, event.text)
          : state.copyWith(aliasError: null),
    );
  }

  void _onAliasSubmitted(
    _AliasSubmitted event,
    Emitter<ProviderFormState> emit,
  ) {
    emit(_withAliases(state, event.text));
  }

  void _onAliasRemoved(_AliasRemoved event, Emitter<ProviderFormState> emit) {
    emit(
      state.copyWith(
        aliases: [...state.aliases]..remove(event.alias),
        aliasError: null,
      ),
    );
  }

  Future<void> _onActiveToggled(
    _ActiveToggled event,
    Emitter<ProviderFormState> emit,
  ) async {
    final original = state.original;
    if (original == null) {
      // A new provider's status is part of the form.
      emit(state.copyWith(isActive: event.active));
    } else if (original.isSystem || state.isWorking) {
      return;
    } else if (event.active) {
      await _changeStatus(emit, active: true);
    } else {
      emit(state.copyWith(dialog: .deactivate));
    }
  }

  /// Opens the system photo picker; the picked image uploads on Save.
  Future<void> _onLogoPickRequested(
    _LogoPickRequested event,
    Emitter<ProviderFormState> emit,
  ) async {
    if (state.isWorking) return;
    final path = await _photos.pick(.gallery);
    if (path != null) emit(state.copyWith(newLogoPath: path));
  }

  void _onDeleteRequested(
    _DeleteRequested event,
    Emitter<ProviderFormState> emit,
  ) {
    if (state.canDelete && !state.isWorking) {
      emit(state.copyWith(dialog: .delete));
    }
  }

  Future<void> _onDialogConfirmed(
    _DialogConfirmed event,
    Emitter<ProviderFormState> emit,
  ) async {
    switch (state.dialog) {
      case .deactivate:
        await _changeStatus(emit, active: false);
      case .delete:
        await _deleteProvider(emit);
      case null:
    }
  }

  void _onDialogDismissed(
    _DialogDismissed event,
    Emitter<ProviderFormState> emit,
  ) {
    emit(state.copyWith(dialog: null));
  }

  Future<void> _changeStatus(
    Emitter<ProviderFormState> emit, {
    required bool active,
  }) async {
    final original = state.original;
    if (original == null) return;
    emit(
      state.copyWith(dialog: null, isChangingStatus: true, actionFailure: null),
    );
    final result = await _setActive(
      SetProviderActiveParams(id: original.id, active: active),
    );
    emit(
      result.match(
        (failure) => state.copyWith(
          isChangingStatus: false,
          actionFailure: ProviderFailure.of(failure),
        ),
        (provider) => state.copyWith(
          isChangingStatus: false,
          isActive: provider.isActive,
          original: provider,
          lastEdited: provider.updatedAt.toLocal(),
        ),
      ),
    );
  }

  Future<void> _deleteProvider(Emitter<ProviderFormState> emit) async {
    final original = state.original;
    if (original == null) return;
    emit(state.copyWith(dialog: null, isDeleting: true, actionFailure: null));
    final result = await _delete(original.id);
    // The list reloads through the change events and no longer shows it.
    emit(
      result.match(
        (failure) => state.copyWith(
          isDeleting: false,
          actionFailure: ProviderFailure.of(failure),
        ),
        (_) => state.copyWith(isDeleting: false, done: true),
      ),
    );
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<ProviderFormState> emit,
  ) async {
    // A typed alias not yet added with Enter is still meant to be saved.
    final withPending = _withAliases(state, event.aliasInput);
    emit(withPending);
    final type = state.type;
    final sortOrder = int.tryParse(event.sortOrder);
    if (!state.canSave ||
        state.status != .success ||
        state.isWorking ||
        type == null ||
        sortOrder == null) {
      return;
    }
    emit(
      state.copyWith(
        isSaving: true,
        nameError: null,
        aliasError: null,
        actionFailure: null,
        logoFailed: false,
      ),
    );
    final input = ProviderInput(
      name: event.name,
      type: type,
      aliases: state.aliases,
      sortOrder: sortOrder,
      isActive: state.isActive,
    );
    final logoPath = state.newLogoPath;
    final result = switch (state.original) {
      null => await _create(
        CreateProviderParams(input: input, logoPath: logoPath),
      ),
      final original => await _update(
        UpdateProviderParams(
          original: original,
          input: input,
          logoPath: logoPath,
        ),
      ),
    };
    emit(_afterSave(result, logoPath));
  }

  ProviderFormState _afterSave(
    Either<Failure, SavedProvider> result,
    String? logoPath,
  ) {
    final saving = state.copyWith(isSaving: false);
    return result.match(
      (failure) {
        if (failure case ValidationFailure(:final fieldErrors)) {
          final nameError = fieldErrors.firstForField(
            ProviderInputValidator.nameField,
          );
          final aliasError = fieldErrors
              .where(
                (e) => e.field.startsWith(ProviderInputValidator.aliasesField),
              )
              .firstOrNull;
          if (nameError != null || aliasError != null) {
            return saving.copyWith(
              nameError: nameError,
              aliasError: aliasError,
            );
          }
        }
        return saving.copyWith(actionFailure: ProviderFailure.of(failure));
      },
      (saved) {
        if (saved.logoFailure == null) return saving.copyWith(done: true);
        // Saved, but the logo wasn't: stay, now editing the saved provider,
        // so the upload can be retried.
        return _filledFrom(
          saving,
          saved.provider,
        ).copyWith(newLogoPath: logoPath, logoFailed: true);
      },
    );
  }

  ProviderFormState _filledFrom(
    ProviderFormState from,
    AdminPaymentProvider provider,
  ) => _withPermissions(
    from.copyWith(
      status: .success,
      loadFailure: null,
      original: provider,
      type: provider.type,
      aliases: provider.aliases,
      isActive: provider.isActive,
      hasName: provider.name.trim().isNotEmpty,
      sortOrderValid: true,
      slug: provider.slug,
      newLogoPath: null,
      lastEdited: provider.updatedAt.toLocal(),
    ),
  );

  ProviderFormState _withPermissions(ProviderFormState from) => from.copyWith(
    canSave: canSaveProvider(_currentUser, isNew: from.original == null),
    canDelete: canDeleteProvider(_currentUser, from.original),
  );

  /// [text]'s comma-separated aliases added; the alias field is cleared.
  ProviderFormState _withAliases(ProviderFormState from, String text) =>
      from.copyWith(
        aliases: withTypedAliases(from.aliases, text),
        aliasInputResets: text.isEmpty
            ? from.aliasInputResets
            : from.aliasInputResets + 1,
        aliasError: null,
      );

  @override
  Future<void> close() async {
    await _user?.cancel();
    return super.close();
  }
}
