part of 'provider_form_bloc.dart';

enum ProviderFormDialog { deactivate, delete }

@freezed
abstract class ProviderFormState with _$ProviderFormState {
  const factory ProviderFormState({
    required bool isNew,
    @Default(UiStatus.initial) UiStatus status,
    ProviderFailure? loadFailure,
    AdminPaymentProvider? original,
    WalletType? type,
    @Default([]) List<String> aliases,
    @Default(true) bool isActive,
    String? newLogoPath,
    @Default('') String slug,
    @Default(false) bool hasName,
    @Default(true) bool sortOrderValid,
    FieldError? nameError,
    FieldError? aliasError,

    /// Bumped each time typed aliases are added, so the screen clears the
    /// alias field.
    @Default(0) int aliasInputResets,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,
    @Default(false) bool isChangingStatus,
    ProviderFormDialog? dialog,
    @Default(false) bool canSave,
    @Default(false) bool canDelete,
    DateTime? lastEdited,
    ProviderFailure? actionFailure,
    @Default(false) bool logoFailed,
    @Default(false) bool done,
  }) = _ProviderFormState;
}

extension ProviderFormStateX on ProviderFormState {
  bool get isWorking => isSaving || isDeleting || isChangingStatus;

  bool get isSystem => original?.isSystem ?? false;

  bool get isReady =>
      canSave &&
      status == .success &&
      !isWorking &&
      hasName &&
      type != null &&
      sortOrderValid;
}
