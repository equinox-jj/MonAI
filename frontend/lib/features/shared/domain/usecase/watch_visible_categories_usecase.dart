import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

/// The categories of one type a picker offers.
class WatchVisibleCategoriesUseCase
    implements StreamUseCase<List<Category>, CategoryType> {
  WatchVisibleCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Stream<Either<Failure, List<Category>>> call(CategoryType type) =>
      _repository.watchVisibleCategories(type);
}
