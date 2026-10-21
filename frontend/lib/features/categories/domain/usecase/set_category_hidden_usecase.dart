import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

typedef SetCategoryHiddenParams = ({String id, bool hidden});

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
