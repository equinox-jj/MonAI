part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  const factory CategoriesEvent.started() = _Started;
  const factory CategoriesEvent.typeSelected(CategoryType type) = _TypeSelected;
  const factory CategoriesEvent.retried() = _Retried;
  const factory CategoriesEvent.hiddenToggled(String id) = _HiddenToggled;

  const factory CategoriesEvent.deleteRequested(String id, {String? moveTo}) =
      _DeleteRequested;

  const factory CategoriesEvent.categoriesChanged(List<Category> categories) =
      _CategoriesChanged;
}
