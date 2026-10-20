part of 'categories_bloc.dart';

@freezed
abstract class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(CategoryType.expense) CategoryType type,

    /// [UiStatus.loading] while nothing is saved and the first load runs,
    /// [UiStatus.failure] when it failed, otherwise [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// Every category, hidden ones included.
    @Default([]) List<Category> categories,

    /// Categories with a hide or delete running.
    @Default({}) Set<String> busyIds,

    /// Why the categories couldn't be loaded.
    CategoryFailure? loadFailure,

    /// A delete was refused for this category's transactions: the screen
    /// asks where to move them.
    Category? moveFrom,

    /// Just deleted; shown once as a snackbar.
    Category? deleted,

    /// Why a hide or delete failed; shown once as a snackbar.
    CategoryFailure? actionFailure,
  }) = _CategoriesState;
}

extension CategoriesStateX on CategoriesState {
  /// The tab's categories, by name with "Other" last.
  List<Category> get shown =>
      sortCategories(categories.where((c) => c.type == type));

  Category? byId(String id) => categories.where((c) => c.id == id).firstOrNull;
}
