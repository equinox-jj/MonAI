part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  /// The screen opened.
  const factory CategoriesEvent.started() = _Started;

  /// The Expense or Income tab.
  const factory CategoriesEvent.typeSelected(CategoryType type) = _TypeSelected;

  /// "Try again" after the categories couldn't be loaded.
  const factory CategoriesEvent.retried() = _Retried;

  /// The eye button: hides a shown category, or shows a hidden one.
  const factory CategoriesEvent.hiddenToggled(String id) = _HiddenToggled;

  /// Delete, once confirmed; with [moveTo] once its transactions have a new
  /// category.
  const factory CategoriesEvent.deleteRequested(String id, {String? moveTo}) =
      _DeleteRequested;

  /// The cached categories changed. Sent by the bloc itself.
  const factory CategoriesEvent.categoriesChanged(List<Category> categories) =
      _CategoriesChanged;
}
