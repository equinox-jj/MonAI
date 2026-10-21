import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/categories/domain/usecase/delete_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/set_category_hidden_usecase.dart';
import 'package:monai/features/categories/presentation/model/category_failure.dart';
import 'package:monai/features/categories/presentation/pages/categories/bloc/categories_bloc.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements CategoryRepository {}

void main() {
  late _MockRepository repository;
  late StreamController<Either<Failure, List<Category>>> cached;

  final food = category(id: 'food', name: 'Food');
  final kopi = category(id: 'kopi', name: 'Kopi', isDefault: false);
  final other = category(id: 'other', name: 'Other', isSystem: true);
  final salary = category(
    id: 'salary',
    name: 'Salary',
    type: CategoryType.income,
  );
  final all = [other, kopi, food, salary];

  setUpAll(() => registerFallbackValue(const CategoryChanges()));

  setUp(() {
    repository = _MockRepository();
    cached = StreamController.broadcast();
    addTearDown(cached.close);
    when(() => repository.watchCategories()).thenAnswer((_) => cached.stream);
    when(() => repository.refreshCategories())
        .thenAnswer((_) async => Right(all));
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  Future<CategoriesBloc> started({bool cache = true}) async {
    final bloc = CategoriesBloc(
      watchCategories: WatchCategoriesUseCase(repository),
      refreshCategories: RefreshCategoriesUseCase(repository),
      setHidden: SetCategoryHiddenUseCase(repository),
      delete: DeleteCategoryUseCase(repository),
    )..add(const CategoriesEvent.started());
    addTearDown(bloc.close);
    await settle();
    if (cache) {
      cached.add(Right(all));
      await settle();
    }
    return bloc;
  }

  Future<void> send(CategoriesBloc bloc, CategoriesEvent event) async {
    bloc.add(event);
    await settle();
  }

  test('shows the expense tab by name with "Other" last', () async {
    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.shown.map((c) => c.id), ['food', 'kopi', 'other']);
  });

  test('the income tab shows income categories', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const CategoriesEvent.typeSelected(CategoryType.income));

    // Assert
    expect(bloc.state.shown.map((c) => c.id), ['salary']);
  });

  test('a first load that fails shows the error', () async {
    // Arrange
    when(() => repository.refreshCategories())
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final bloc = await started(cache: false);

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, CategoryFailure.network);
  });

  test('hiding a default category asks the server', () async {
    // Arrange
    when(() => repository.updateCategory(any(), any()))
        .thenAnswer((_) async => Right(food));
    final bloc = await started();

    // Act
    await send(bloc, const CategoriesEvent.hiddenToggled('food'));

    // Assert
    verify(
      () => repository.updateCategory(
        'food',
        const CategoryChanges(isHidden: true),
      ),
    ).called(1);
    expect(bloc.state.busyIds, isEmpty);
  });

  test('"Other" is never hidden or deleted', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const CategoriesEvent.hiddenToggled('other'));
    await send(bloc, const CategoriesEvent.deleteRequested('other'));

    // Assert
    verifyNever(() => repository.updateCategory(any(), any()));
    verifyNever(
      () => repository.deleteCategory(any(), moveTo: any(named: 'moveTo')),
    );
  });

  test('deleting an unused custom category says it is gone', () async {
    // Arrange
    when(() => repository.deleteCategory('kopi'))
        .thenAnswer((_) async => const Right(unit));
    final bloc = await started();

    // Act
    await send(bloc, const CategoriesEvent.deleteRequested('kopi'));

    // Assert
    expect(bloc.state.deleted, kopi);
    expect(bloc.state.moveFrom, isNull);
  });

  test('a category with transactions asks where to move them', () async {
    // Arrange
    when(() => repository.deleteCategory('kopi')).thenAnswer(
      (_) async =>
          const Left(Failure.validation([], code: 'category_has_transactions')),
    );
    when(() => repository.deleteCategory('kopi', moveTo: 'other'))
        .thenAnswer((_) async => const Right(unit));
    final bloc = await started();

    // Act
    await send(bloc, const CategoriesEvent.deleteRequested('kopi'));

    // Assert
    expect(bloc.state.moveFrom, kopi);
    expect(bloc.state.deleted, isNull);

    // Act
    await send(
      bloc,
      const CategoriesEvent.deleteRequested('kopi', moveTo: 'other'),
    );

    // Assert
    expect(bloc.state.deleted, kopi);
    expect(bloc.state.moveFrom, isNull);
  });

  test('a failed hide says why', () async {
    // Arrange
    when(() => repository.updateCategory(any(), any())).thenAnswer(
      (_) async =>
          const Left(Failure.validation([], code: 'system_category_locked')),
    );
    final bloc = await started();

    // Act
    await send(bloc, const CategoriesEvent.hiddenToggled('food'));

    // Assert
    expect(bloc.state.actionFailure, CategoryFailure.locked);
  });
}
