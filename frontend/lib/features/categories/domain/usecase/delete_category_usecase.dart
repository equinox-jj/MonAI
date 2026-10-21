import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

/// The category to delete, and where its transactions go when it has any.
typedef DeleteCategoryParams = ({String id, String? moveTo});

/// Deletes a custom category. One with transactions fails with
/// [hasTransactionsCode] until [DeleteCategoryParams.moveTo] is given.
class DeleteCategoryUseCase implements UseCase<Unit, DeleteCategoryParams> {
  DeleteCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  /// The server's `error.code` for a category that still has transactions.
  static const hasTransactionsCode = 'category_has_transactions';

  @override
  Future<Either<Failure, Unit>> call(DeleteCategoryParams params) =>
      _repository.deleteCategory(params.id, moveTo: params.moveTo);
}
