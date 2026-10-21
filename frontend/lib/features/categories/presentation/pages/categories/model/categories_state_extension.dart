import 'package:monai/features/categories/domain/logic/category_rules.dart';
import 'package:monai/features/categories/presentation/pages/categories/bloc/categories_bloc.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

extension CategoriesStateX on CategoriesState {
  List<Category> get shown =>
      sortCategories(categories.where((c) => c.type == type));

  Category? byId(String id) => categories.where((c) => c.id == id).firstOrNull;
}
