part of 'category_form_bloc.dart';

@freezed
abstract class CategoryFormState with _$CategoryFormState {
  const factory CategoryFormState({
    required CategoryFormMode mode,

    /// [UiStatus.loading] while the edited category loads, otherwise
    /// [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// The category's type; an edited one keeps its own.
    required CategoryType type,

    /// The category being edited.
    Category? original,
    @Default(defaultCategoryIcon) String icon,
    @Default(defaultCategoryColor) String color,

    /// The name's error, shown under the field.
    FieldError? nameError,

    /// A save failed on the name, so its error updates as the user types.
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,

    /// Set once saved, or when the edited category is gone; the screen
    /// closes.
    @Default(false) bool done,

    /// Why a save failed, or why the form closed early; shown once as a
    /// snackbar.
    CategoryFailure? actionFailure,
  }) = _CategoryFormState;
}

extension CategoryFormStateX on CategoryFormState {
  bool get isEdit => mode is EditCategoryMode;

  /// Only a custom category can be deleted from the form.
  bool get canDelete => original?.canDelete ?? false;
}
