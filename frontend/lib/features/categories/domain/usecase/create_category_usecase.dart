import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/categories/domain/validation/category_input_validator.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

class CreateCategoryUseCase implements UseCase<Category, CategoryInput> {
  CreateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Category>> call(CategoryInput params) async {
    final input = params.normalized;
    final errors = CategoryInputValidator.validate(input);
    if (errors.isNotEmpty) return Left(Failure.validation(errors));
    return _repository.createCategory(input);
  }
}
