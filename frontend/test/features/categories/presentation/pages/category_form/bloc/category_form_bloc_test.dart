import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/categories/domain/usecase/create_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/find_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:monai/features/categories/presentation/model/category_failure.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements CategoryRepository {}

void main() {
  late _MockRepository repository;
  final kopi = category(
    id: 'kopi',
    name: 'Kopi',
    icon: 'local_cafe',
    color: '#6366f1',
    isDefault: false,
  );

  setUpAll(() {
    registerFallbackValue(
      const CategoryInput(name: '', type: CategoryType.expense),
    );
    registerFallbackValue(const CategoryChanges());
  });

  setUp(() => repository = _MockRepository());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  Future<CategoryFormBloc> started(CategoryFormMode mode) async {
    final bloc = CategoryFormBloc(
      mode: mode,
      find: FindCategoryUseCase(repository),
      create: CreateCategoryUseCase(repository),
      update: UpdateCategoryUseCase(repository),
    )..add(const CategoryFormEvent.started());
    addTearDown(bloc.close);
    await settle();
    return bloc;
  }

  Future<void> send(CategoryFormBloc bloc, CategoryFormEvent event) async {
    bloc.add(event);
    await settle();
  }

  test('a new category starts as coffee in orange', () async {
    // Act
    final bloc = await started(
      const CategoryFormMode.create(CategoryType.income),
    );

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.type, CategoryType.income);
    expect(bloc.state.icon, 'local_cafe');
    expect(bloc.state.color, '#F97316');
  });

  test('creating sends the picks and closes', () async {
    // Arrange
    when(() => repository.createCategory(any()))
        .thenAnswer((_) async => Right(kopi));
    final bloc = await started(
      const CategoryFormMode.create(CategoryType.expense),
    );
    await send(bloc, const CategoryFormEvent.iconPicked('pets'));
    await send(bloc, const CategoryFormEvent.colorPicked('#14B8A6'));

    // Act
    await send(bloc, const CategoryFormEvent.saveRequested('Kucing'));

    // Assert
    verify(
      () => repository.createCategory(
        const CategoryInput(
          name: 'Kucing',
          type: CategoryType.expense,
          icon: 'pets',
          color: '#14B8A6',
        ),
      ),
    ).called(1);
    expect(bloc.state.done, isTrue);
  });

  test('a taken name shows under the field and keeps the form', () async {
    // Arrange
    when(() => repository.createCategory(any()))
        .thenAnswer((_) async => const Left(Failure.conflict()));
    final bloc = await started(
      const CategoryFormMode.create(CategoryType.expense),
    );

    // Act
    await send(bloc, const CategoryFormEvent.saveRequested('Food'));

    // Assert
    expect(bloc.state.nameError?.code, 'conflict');
    expect(bloc.state.done, isFalse);
  });

  test('a blank name re-checks as it is typed', () async {
    // Arrange
    final bloc = await started(
      const CategoryFormMode.create(CategoryType.expense),
    );
    await send(bloc, const CategoryFormEvent.saveRequested(''));
    expect(bloc.state.nameError?.code, 'required');

    // Act
    await send(bloc, const CategoryFormEvent.nameEdited('K'));

    // Assert
    expect(bloc.state.nameError, isNull);
  });

  test('editing loads the category with its picks', () async {
    // Arrange
    when(() => repository.findCategory('kopi'))
        .thenAnswer((_) async => Right(kopi));

    // Act
    final bloc = await started(const CategoryFormMode.edit('kopi'));

    // Assert
    expect(bloc.state.original, kopi);
    expect(bloc.state.icon, 'local_cafe');
    expect(bloc.state.color, '#6366F1');
    expect(bloc.state.canDelete, isTrue);
  });

  test('a category that is gone closes the form', () async {
    // Arrange
    when(() => repository.findCategory('kopi'))
        .thenAnswer((_) async => const Right(null));

    // Act
    final bloc = await started(const CategoryFormMode.edit('kopi'));

    // Assert
    expect(bloc.state.done, isTrue);
    expect(bloc.state.actionFailure, CategoryFailure.notFound);
  });
}
