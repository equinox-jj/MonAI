import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

class FindCategoryUseCase implements UseCase<Category?, String> {
  FindCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Category?>> call(String id) =>
      _repository.findCategory(id);
}
