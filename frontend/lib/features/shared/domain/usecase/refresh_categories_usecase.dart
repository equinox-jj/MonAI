import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

/// Re-fetches every category.
class RefreshCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  RefreshCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) =>
      _repository.refreshCategories();
}
