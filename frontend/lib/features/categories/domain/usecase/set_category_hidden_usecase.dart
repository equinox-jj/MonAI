import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

/// The category and whether to hide it from pickers.
typedef SetCategoryHiddenParams = ({String id, bool hidden});

/// Hides a category from pickers, or shows it again.
class SetCategoryHiddenUseCase
    implements UseCase<Category, SetCategoryHiddenParams> {
  SetCategoryHiddenUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Category>> call(SetCategoryHiddenParams params) =>
      _repository.updateCategory(
        params.id,
        CategoryChanges(isHidden: params.hidden),
      );
}
