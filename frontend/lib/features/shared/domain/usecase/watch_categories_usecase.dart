import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

class WatchCategoriesUseCase
    implements StreamUseCase<List<Category>, NoParams> {
  WatchCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Stream<Either<Failure, List<Category>>> call(NoParams params) =>
      _repository.watchCategories();
}
