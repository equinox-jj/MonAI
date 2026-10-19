import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/data/datasources/category_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/category_mapper.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository with BaseRepository {
  CategoryRepositoryImpl({required this._remote, required this._local});

  final CategoryRemoteDataSource _remote;
  final CategoryLocalDataSource _local;

  @override
  Stream<Either<Failure, List<Category>>> watchCategories() => safeStream(
    () => _local.watchAll().map(
      (rows) => rows.map((row) => row.toEntity()).toList(),
    ),
  );

  @override
  Stream<Either<Failure, List<Category>>> watchVisibleCategories(
    CategoryType type,
  ) => safeStream(
    () => _local
        .watchByType(type)
        .map(
          (rows) => [
            for (final row in rows)
              if (!row.isHidden) row.toEntity(),
          ],
        ),
  );

  @override
  Future<Either<Failure, List<Category>>> refreshCategories() =>
      safeCall(() async {
        final response = await _remote.getCategories();
        final rows = (response.data ?? const [])
            .map((data) => data.toRow())
            .toList();
        await _local.replaceAll(rows);
        return rows.map((row) => row.toEntity()).toList();
      });
}
