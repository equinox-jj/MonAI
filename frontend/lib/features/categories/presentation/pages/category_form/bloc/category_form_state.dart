part of 'category_form_bloc.dart';

@freezed
abstract class CategoryFormState with _$CategoryFormState {
  const factory CategoryFormState({
    required CategoryFormMode mode,
    @Default(UiStatus.initial) UiStatus status,
    required CategoryType type,
    Category? original,
    @Default(defaultCategoryIcon) String icon,
    @Default(defaultCategoryColor) String color,
    FieldError? nameError,
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool done,
    String? savedId,
    CategoryFailure? actionFailure,
  }) = _CategoryFormState;
}
