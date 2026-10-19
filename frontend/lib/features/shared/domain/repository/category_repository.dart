import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

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
}
