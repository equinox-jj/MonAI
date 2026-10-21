part of 'provider_form_bloc.dart';

/// A confirmation over the provider form.
enum ProviderFormDialog { deactivate, delete }

@freezed
abstract class ProviderFormState with _$ProviderFormState {
  const factory ProviderFormState({
    /// Adding a provider rather than editing one.
    required bool isNew,

    /// [UiStatus.success] once the form can be filled in: at once for a new
    /// provider, after the load for an existing one.
    @Default(UiStatus.initial) UiStatus status,
    ProviderFailure? loadFailure,

    /// The provider as last loaded or saved; null for a new one.
    AdminPaymentProvider? original,
    WalletType? type,
    @Default([]) List<String> aliases,
    @Default(true) bool isActive,

    /// A picked logo, uploaded on Save.
    String? newLogoPath,

    /// The provider's ID: its own when editing, else what the server will
    /// make from the name; empty while there is no name.
    @Default('') String slug,

    /// The name field isn't blank.
    @Default(false) bool hasName,

    /// The sort order field holds a number.
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

    /// The user may save this form (create or update permission).
    @Default(false) bool canSave,

    /// The user may delete this provider.
    @Default(false) bool canDelete,

    /// When it was last saved, in local time.
    DateTime? lastEdited,

    /// Why the last action (save, status, delete) failed; shown once.
    ProviderFailure? actionFailure,

    /// The provider saved but its logo didn't; shown once.
    @Default(false) bool logoFailed,

    /// Saved or deleted: the form closes.
    @Default(false) bool done,
  }) = _ProviderFormState;
}

extension ProviderFormStateX on ProviderFormState {
  /// A save, status change or delete is running.
  bool get isWorking => isSaving || isDeleting || isChangingStatus;

  /// A system provider: always active, never deleted.
  bool get isSystem => original?.isSystem ?? false;

  /// Save can be tapped.
  bool get isReady =>
      canSave &&
      status == .success &&
      !isWorking &&
      hasName &&
      type != null &&
      sortOrderValid;
}
