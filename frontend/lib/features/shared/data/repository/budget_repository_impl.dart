import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/data/datasources/budget_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/budget_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/budget_mapper.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';

class BudgetRepositoryImpl extends BudgetRepository with BaseRepository {
  BudgetRepositoryImpl({required this._remote, required this._local});

  final BudgetRemoteDataSource _remote;
  final BudgetLocalDataSource _local;

  @override
  Stream<Either<Failure, Budget?>> watchBudget(DateTime month) =>
      safeStream(() => _local.watch(month).map((row) => row?.toEntity()));

  // A 404 means no budget is set for the month: not an error.
  @override
  Future<Either<Failure, Budget?>> refreshBudget(DateTime month) =>
      safeCall(() async {
        try {
          final response = await _remote.getBudget(formatApiMonth(month));
          final row = requireField(response.data).toRow();
          await _local.upsert(row);
          return row.toEntity();
        } on NotFoundException {
          await _local.deleteByMonth(month);
          return null;
        }
      });
}
