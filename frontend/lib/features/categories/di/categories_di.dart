import 'package:monai/core/app/injector.dart';
import 'package:monai/features/categories/domain/usecase/create_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/delete_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/find_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/set_category_hidden_usecase.dart';
import 'package:monai/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:monai/features/categories/presentation/pages/categories/bloc/categories_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';

class CategoriesDI {
  CategoriesDI._();

  static Future<void> init() async {
    sl
      ..registerFactory(() => FindCategoryUseCase(sl()))
      ..registerFactory(() => CreateCategoryUseCase(sl()))
      ..registerFactory(() => UpdateCategoryUseCase(sl()))
      ..registerFactory(() => SetCategoryHiddenUseCase(sl()))
      ..registerFactory(() => DeleteCategoryUseCase(sl()))
      ..registerFactory(
        () => CategoriesBloc(
          watchCategories: sl(),
          refreshCategories: sl(),
          setHidden: sl(),
          delete: sl(),
        ),
      )
      ..registerFactoryParam<CategoryFormBloc, CategoryFormMode, void>(
        (mode, _) => CategoryFormBloc(
          mode: mode,
          find: sl(),
          create: sl(),
          update: sl(),
        ),
      );
  }
}
