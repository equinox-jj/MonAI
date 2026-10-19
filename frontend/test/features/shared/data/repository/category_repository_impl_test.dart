import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/data/datasources/category_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/category_mapper.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';
import 'package:monai/features/shared/data/repository/category_repository_impl.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements CategoryRemoteDataSource {}

class _MockLocal extends Mock implements CategoryLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late CategoryRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = CategoryRepositoryImpl(remote: remote, local: local);
  });

  test('refresh replaces the cache with every category', () async {
    // Arrange
    when(() => remote.getCategories()).thenAnswer(
      (_) async => CategoryListResponse.fromJson(
        envelope([
          categoryJson(id: 'c1'),
          categoryJson(id: 'c2', type: 'INCOME', isHidden: true),
        ]),
      ),
    );
    when(() => local.replaceAll(any())).thenAnswer((_) async {});

    // Act
    final result = await repository.refreshCategories();

    // Assert
    final rows =
        verify(() => local.replaceAll(captureAny())).captured.single
            as List<CategoryRow>;
    expect(
      result.getRight().toNullable(),
      rows.map((row) => row.toEntity()).toList(),
    );
    expect(rows.map((row) => (row.id, row.type, row.isHidden)), [
      ('c1', CategoryType.expense, false),
      ('c2', CategoryType.income, true),
    ]);
  });

  test('pickers leave hidden categories out', () async {
    // Arrange
    when(() => local.watchByType(CategoryType.expense)).thenAnswer(
      (_) => Stream.value([
        categoryRow(id: 'c1'),
        categoryRow(id: 'c2').copyWith(isHidden: true),
      ]),
    );

    // Act
    final result = await repository
        .watchVisibleCategories(CategoryType.expense)
        .first;

    // Assert
    expect(result.getRight().toNullable()?.map((c) => c.id), ['c1']);
  });

  test('labels keep hidden categories', () async {
    // Arrange
    when(() => local.watchAll()).thenAnswer(
      (_) => Stream.value([
        categoryRow(id: 'c1'),
        categoryRow(id: 'c2').copyWith(isHidden: true),
      ]),
    );

    // Act
    final result = await repository.watchCategories().first;

    // Assert
    expect(result.getRight().toNullable(), hasLength(2));
  });
}
