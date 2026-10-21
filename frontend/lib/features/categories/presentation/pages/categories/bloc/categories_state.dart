part of 'categories_bloc.dart';

@freezed
abstract class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(CategoryType.expense) CategoryType type,
    @Default(UiStatus.initial) UiStatus status,
    @Default([]) List<Category> categories,
    @Default({}) Set<String> busyIds,
    CategoryFailure? loadFailure,
    Category? moveFrom,
    Category? deleted,
    CategoryFailure? actionFailure,
  }) = _CategoriesState;
}

extension CategoriesStateX on CategoriesState {
  List<Category> get shown =>
      sortCategories(categories.where((c) => c.type == type));

  Category? byId(String id) => categories.where((c) => c.id == id).firstOrNull;
}
