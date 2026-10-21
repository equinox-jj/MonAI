import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/categories/domain/validation/category_input_validator.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

typedef UpdateCategoryParams = ({Category original, CategoryInput input});

/// Sends only what changed; nothing changed succeeds at once with the
/// category as it was.
class UpdateCategoryUseCase implements UseCase<Category, UpdateCategoryParams> {
  UpdateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Category>> call(UpdateCategoryParams params) async {
    final original = params.original;
    final input = params.input.normalized;
    final errors = CategoryInputValidator.validate(input);
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    final changes = CategoryChanges(
      name: input.name == original.name ? null : input.name,
      icon: input.icon == original.icon ? null : input.icon,
      color: input.color == original.color ? null : input.color,
    );
    if (changes.isEmpty) return Right(original);
    return _repository.updateCategory(original.id, changes);
  }
}
