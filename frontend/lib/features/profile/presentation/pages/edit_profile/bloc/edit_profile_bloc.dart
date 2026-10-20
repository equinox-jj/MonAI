import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/services/avatar_photo_service.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/profile/domain/usecase/change_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/delete_account_usecase.dart';
import 'package:monai/features/profile/domain/usecase/remove_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/update_profile_name_usecase.dart';
import 'package:monai/features/profile/domain/validation/profile_input_validator.dart';
import 'package:monai/features/profile/presentation/model/profile_failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

part 'edit_profile_bloc.freezed.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

/// The display name, the profile photo and deleting the account. The name
/// and the password live in the screen's text fields and arrive with their
/// edits and the actions. The account's deletion ends the session, and
/// navigation follows it to Sign in.
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required this._watchUser,
    required this._updateName,
    required this._changeAvatar,
    required this._removeAvatar,
    required this._deleteAccount,
    required this._photos,
  }) : super(const EditProfileState()) {
    on<_Started>(_onStarted);
    on<_UserChanged>(_onUserChanged);
    on<_NameEdited>(_onNameEdited);
    on<_SaveRequested>(_onSaveRequested);
    on<_PhotoSourcePicked>(_onPhotoSourcePicked);
    on<_RemovePhotoRequested>(_onRemovePhotoRequested);
    on<_PasswordEdited>(_onPasswordEdited);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_DeleteConfirmed>(_onDeleteConfirmed);
  }

  final WatchUserUseCase _watchUser;
  final UpdateProfileNameUseCase _updateName;
  final ChangeAvatarUseCase _changeAvatar;
  final RemoveAvatarUseCase _removeAvatar;
  final DeleteAccountUseCase _deleteAccount;
  final AvatarPhotoService _photos;

  StreamSubscription<void>? _user;

  /// The name field's text, to tell whether it differs from the saved one.
  String? _typedName;

  void _onStarted(_Started event, Emitter<EditProfileState> emit) {
    _user = _watchUser(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (user) => add(EditProfileEvent.userChanged(user)),
      ),
    );
  }

  void _onUserChanged(_UserChanged event, Emitter<EditProfileState> emit) =>
      emit(
        state.copyWith(
          user: event.user,
          nameChanged: _changed(_typedName, event.user),
        ),
      );

  static bool _changed(String? typed, User? user) =>
      typed != null &&
      user != null &&
      ProfileInputValidator.normalizedName(typed) != user.name;

  void _onNameEdited(_NameEdited event, Emitter<EditProfileState> emit) {
    _typedName = event.text;
    final error = state.autovalidate
        ? ProfileInputValidator.name(
            ProfileInputValidator.normalizedName(event.text),
          )
        : null;
    emit(
      state.copyWith(
        nameChanged: _changed(event.text, state.user),
        nameError: error,
      ),
    );
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    if (!state.canSave) return;
    emit(state.copyWith(isSavingName: true, nameError: null));
    final result = await _updateName(event.name);
    switch (result) {
      case Right(value: final user):
        _typedName = user.name;
        emit(
          state.copyWith(
            user: user,
            isSavingName: false,
            nameChanged: false,
            autovalidate: false,
            notice: ProfileNotice.nameSaved,
          ),
        );
        emit(state.copyWith(notice: null));
      case Left(value: ValidationFailure(:final fieldErrors))
          when fieldErrors.any(
            (e) => e.field == ProfileInputValidator.nameField,
          ):
        emit(
          state.copyWith(
            isSavingName: false,
            autovalidate: true,
            nameError: fieldErrors.firstWhere(
              (e) => e.field == ProfileInputValidator.nameField,
            ),
          ),
        );
      case Left(value: final failure):
        _fail(emit, failure, state.copyWith(isSavingName: false));
    }
  }

  Future<void> _onPhotoSourcePicked(
    _PhotoSourcePicked event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.isChangingPhoto) return;
    emit(state.copyWith(isPreparingPhoto: true));
    final labels = event.cropLabels;
    final picked = await _photos.pick(event.source);
    final cropped = picked == null
        ? null
        : await _photos.cropSquare(
            picked,
            title: labels.title,
            done: labels.done,
            cancel: labels.cancel,
          );
    if (cropped == null) {
      emit(state.copyWith(isPreparingPhoto: false));
      return;
    }
    emit(state.copyWith(isPreparingPhoto: false, uploadProgress: 0));
    final result = await _changeAvatar(
      ChangeAvatarParams(
        path: cropped,
        onProgress: (progress) {
          if (!emit.isDone) emit(state.copyWith(uploadProgress: progress));
        },
      ),
    );
    switch (result) {
      case Right(value: final user):
        emit(
          state.copyWith(
            user: user,
            uploadProgress: null,
            notice: ProfileNotice.photoUpdated,
          ),
        );
        emit(state.copyWith(notice: null));
      case Left(value: final failure):
        _fail(emit, failure, state.copyWith(uploadProgress: null));
    }
  }

  Future<void> _onRemovePhotoRequested(
    _RemovePhotoRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.isChangingPhoto || !state.hasPhoto) return;
    emit(state.copyWith(isRemovingPhoto: true));
    final result = await _removeAvatar(const NoParams());
    switch (result) {
      case Right():
        emit(
          state.copyWith(
            isRemovingPhoto: false,
            notice: ProfileNotice.photoRemoved,
          ),
        );
        emit(state.copyWith(notice: null));
      case Left(value: final failure):
        _fail(emit, failure, state.copyWith(isRemovingPhoto: false));
    }
  }

  void _onPasswordEdited(
    _PasswordEdited event,
    Emitter<EditProfileState> emit,
  ) {
    if (state.passwordError != null) {
      emit(state.copyWith(passwordError: null));
    }
  }

  void _onDeleteRequested(
    _DeleteRequested event,
    Emitter<EditProfileState> emit,
  ) {
    if (state.isDeleting) return;
    if (ProfileInputValidator.password(event.password) case final error?) {
      emit(state.copyWith(passwordError: error));
      return;
    }
    emit(state.copyWith(askDelete: true));
    emit(state.copyWith(askDelete: false));
  }

  Future<void> _onDeleteConfirmed(
    _DeleteConfirmed event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.isDeleting) return;
    emit(state.copyWith(isDeleting: true, passwordError: null));
    final result = await _deleteAccount(event.password);
    switch (result) {
      // The session ended; the router leaves for Sign in.
      case Right():
        emit(state.copyWith(isDeleting: false));
      case Left(value: ValidationFailure(:final fieldErrors))
          when fieldErrors.any(
            (e) => e.field == ProfileInputValidator.passwordField,
          ):
        emit(
          state.copyWith(
            isDeleting: false,
            passwordError: fieldErrors.firstWhere(
              (e) => e.field == ProfileInputValidator.passwordField,
            ),
          ),
        );
      case Left(value: final failure) when failure.code == 'invalid_password':
        emit(
          state.copyWith(
            isDeleting: false,
            passwordError: FieldError(
              field: ProfileInputValidator.passwordField,
              code: 'invalid_password',
              message: failure.message,
            ),
          ),
        );
      case Left(value: final failure):
        _fail(emit, failure, state.copyWith(isDeleting: false));
    }
  }

  /// Reports [failure] once, from [next].
  void _fail(
    Emitter<EditProfileState> emit,
    Failure failure,
    EditProfileState next,
  ) {
    emit(next.copyWith(failure: ProfileFailure.of(failure)));
    emit(state.copyWith(failure: null));
  }

  @override
  Future<void> close() async {
    await _user?.cancel();
    return super.close();
  }
}
