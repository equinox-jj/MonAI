import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

/// The user's categories.
abstract class CategoryRepository {
  /// Every category, hidden ones included, to label old transactions.
  Stream<Either<Failure, List<Category>>> watchCategories();

  /// The categories of [type] a picker offers: hidden ones left out.
  Stream<Either<Failure, List<Category>>> watchVisibleCategories(
    CategoryType type,
  );

  /// Replaces the cache with the server's categories and gives them, hidden
  /// ones included.
  Future<Either<Failure, List<Category>>> refreshCategories();

  /// The cached category [id], or null when it isn't cached.
  Future<Either<Failure, Category?>> findCategory(String id);

  /// Creates a category and caches it.
  Future<Either<Failure, Category>> createCategory(CategoryInput input);

  /// Applies [changes] to category [id] and caches the result.
  Future<Either<Failure, Category>> updateCategory(
    String id,
    CategoryChanges changes,
  );

  /// Deletes category [id]. One with transactions fails with the
  /// `category_has_transactions` code unless [moveTo] names the category of
  /// the same type to move them to.
  Future<Either<Failure, Unit>> deleteCategory(String id, {String? moveTo});
}
