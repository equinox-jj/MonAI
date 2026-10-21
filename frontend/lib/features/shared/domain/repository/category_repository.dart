import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

abstract class CategoryRepository {
  /// Hidden ones included, to label old transactions.
  Stream<Either<Failure, List<Category>>> watchCategories();

  Stream<Either<Failure, List<Category>>> watchVisibleCategories(
    CategoryType type,
  );

  Future<Either<Failure, List<Category>>> refreshCategories();

  Future<Either<Failure, Category?>> findCategory(String id);

  Future<Either<Failure, Category>> createCategory(CategoryInput input);

  Future<Either<Failure, Category>> updateCategory(
    String id,
    CategoryChanges changes,
  );

  /// One with transactions fails with `category_has_transactions` unless
  /// [moveTo] names a category of the same type to move them to.
  Future<Either<Failure, Unit>> deleteCategory(String id, {String? moveTo});
}
