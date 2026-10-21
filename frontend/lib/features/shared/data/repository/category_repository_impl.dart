import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/data/datasources/category_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/category_mapper.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/category_response.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';
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

  @override
  Future<Either<Failure, Category?>> findCategory(String id) =>
      safeCall(() async => (await _local.find(id))?.toEntity());

  @override
  Future<Either<Failure, Category>> createCategory(CategoryInput input) =>
      _write(() => _remote.createCategory(input.toRequest()));

  @override
  Future<Either<Failure, Category>> updateCategory(
    String id,
    CategoryChanges changes,
  ) => _write(() => _remote.updateCategory(id, changes.toRequest()));

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id, {String? moveTo}) =>
      safeCall(() async {
        await _remote.deleteCategory(id, moveTo: moveTo);
        await _local.delete(id, moveTo: moveTo);
        return unit;
      });

  Future<Either<Failure, Category>> _write(
    Future<CategoryResponse> Function() request,
  ) => safeCall(() async {
    final row = requireField((await request()).data).toRow();
    await _local.save(row);
    return row.toEntity();
  });
}
