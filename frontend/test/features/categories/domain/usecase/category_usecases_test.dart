import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/categories/domain/usecase/create_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/set_category_hidden_usecase.dart';
import 'package:monai/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements CategoryRepository {}

void main() {
  late _MockRepository repository;
  final kopi = category(
    id: 'kopi',
    name: 'Kopi',
    icon: 'local_cafe',
    color: '#F97316',
    isDefault: false,
  );

  setUpAll(() {
    registerFallbackValue(
      const CategoryInput(name: '', type: CategoryType.expense),
    );
    registerFallbackValue(const CategoryChanges());
  });

  setUp(() => repository = _MockRepository());

  group('CreateCategoryUseCase', () {
    test('trims the name before saving', () async {
      // Arrange
      when(() => repository.createCategory(any()))
          .thenAnswer((_) async => Right(kopi));

      // Act
      await CreateCategoryUseCase(repository)(
        const CategoryInput(name: '  Kopi ', type: CategoryType.expense),
      );

      // Assert
      final sent =
          verify(() => repository.createCategory(captureAny())).captured.single
              as CategoryInput;
      expect(sent.name, 'Kopi');
    });

    test('a blank name fails without asking the server', () async {
      // Act
      final result = await CreateCategoryUseCase(repository)(
        const CategoryInput(name: ' ', type: CategoryType.expense),
      );

      // Assert
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyNever(() => repository.createCategory(any()));
    });
  });

  group('UpdateCategoryUseCase', () {
    test('sends only what changed', () async {
      // Arrange
      when(() => repository.updateCategory(any(), any()))
          .thenAnswer((_) async => Right(kopi));

      // Act
      await UpdateCategoryUseCase(repository)((
        original: kopi,
        input: const CategoryInput(
          name: 'Kopi',
          type: CategoryType.expense,
          icon: 'restaurant',
          color: '#F97316',
        ),
      ));

      // Assert
      verify(
        () => repository.updateCategory(
          'kopi',
          const CategoryChanges(icon: 'restaurant'),
        ),
      ).called(1);
    });

    test('nothing changed succeeds without a request', () async {
      // Act
      final result = await UpdateCategoryUseCase(repository)((
        original: kopi,
        input: const CategoryInput(
          name: 'Kopi ',
          type: CategoryType.expense,
          icon: 'local_cafe',
          color: '#F97316',
        ),
      ));

      // Assert
      expect(result, Right<Failure, Category>(kopi));
      verifyNever(() => repository.updateCategory(any(), any()));
    });
  });

  test('SetCategoryHiddenUseCase sends only the hidden flag', () async {
    // Arrange
    when(() => repository.updateCategory(any(), any()))
        .thenAnswer((_) async => Right(kopi));

    // Act
    await SetCategoryHiddenUseCase(repository)((id: 'food', hidden: true));

    // Assert
    verify(
      () => repository.updateCategory(
        'food',
        const CategoryChanges(isHidden: true),
      ),
    ).called(1);
  });
}
