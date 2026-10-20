import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/data/datasources/category_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/category_mapper.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';
import 'package:monai/features/shared/data/model/category_response.dart';
import 'package:monai/features/shared/data/model/create_category_request.dart';
import 'package:monai/features/shared/data/model/update_category_request.dart';
import 'package:monai/features/shared/data/repository/category_repository_impl.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements CategoryRemoteDataSource {}

class _MockLocal extends Mock implements CategoryLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late CategoryRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(categoryRow());
    registerFallbackValue(const CreateCategoryRequest(name: '', type: ''));
    registerFallbackValue(const UpdateCategoryRequest());
  });

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

  test('createCategory sends the input and caches the result', () async {
    // Arrange
    when(() => remote.createCategory(any())).thenAnswer(
      (_) async =>
          CategoryResponse.fromJson(envelope(categoryJson(id: 'kopi'))),
    );
    when(() => local.save(any())).thenAnswer((_) async {});

    // Act
    final result = await repository.createCategory(
      const CategoryInput(
        name: 'Kopi',
        type: CategoryType.expense,
        icon: 'local_cafe',
        color: '#F97316',
      ),
    );

    // Assert
    final request =
        verify(() => remote.createCategory(captureAny())).captured.single
            as CreateCategoryRequest;
    expect(request.toJson(), {
      'name': 'Kopi',
      'type': 'EXPENSE',
      'icon': 'local_cafe',
      'color': '#F97316',
    });
    final row =
        verify(() => local.save(captureAny())).captured.single as CategoryRow;
    expect(row.id, 'kopi');
    expect(result.getRight().toNullable(), row.toEntity());
  });

  test('a taken name fails with a conflict and caches nothing', () async {
    // Arrange
    when(() => remote.createCategory(any()))
        .thenThrow(const ConflictException(code: 'conflict'));

    // Act
    final result = await repository.createCategory(
      const CategoryInput(name: 'Food', type: CategoryType.expense),
    );

    // Assert
    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
    verifyNever(() => local.save(any()));
  });

  test('updateCategory sends only the changed fields', () async {
    // Arrange
    when(() => remote.updateCategory(any(), any())).thenAnswer(
      (_) async =>
          CategoryResponse.fromJson(envelope(categoryJson(isHidden: true))),
    );
    when(() => local.save(any())).thenAnswer((_) async {});

    // Act
    final result = await repository.updateCategory(
      'c1',
      const CategoryChanges(isHidden: true),
    );

    // Assert
    final request =
        verify(() => remote.updateCategory('c1', captureAny())).captured.single
            as UpdateCategoryRequest;
    expect(request.toJson(), {'is_hidden': true});
    expect(result.getRight().toNullable()?.isHidden, isTrue);
  });

  test('deleteCategory moves the cached transactions too', () async {
    // Arrange
    when(() => remote.deleteCategory('c1', moveTo: 'other'))
        .thenAnswer((_) async {});
    when(() => local.delete('c1', moveTo: 'other')).thenAnswer((_) async {});

    // Act
    final result = await repository.deleteCategory('c1', moveTo: 'other');

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(() => local.delete('c1', moveTo: 'other')).called(1);
  });

  test(
    'a category with transactions is kept until a target is chosen',
    () async {
      // Arrange
      when(() => remote.deleteCategory('c1')).thenThrow(
        const ValidationException([], code: 'category_has_transactions'),
      );

      // Act
      final result = await repository.deleteCategory('c1');

      // Assert
      expect(result.getLeft().toNullable()?.code, 'category_has_transactions');
      verifyNever(() => local.delete(any(), moveTo: any(named: 'moveTo')));
    },
  );
}
