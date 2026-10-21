import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/categories/domain/usecase/delete_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/set_category_hidden_usecase.dart';
import 'package:monai/features/categories/presentation/pages/categories/bloc/categories_bloc.dart';
import 'package:monai/features/categories/presentation/pages/categories/categories_page.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements CategoryRepository {}

void main() {
  final food = category(id: 'food', name: 'Food');
  final kopi = category(
    id: 'kopi',
    name: 'Kopi',
    icon: 'local_cafe',
    isDefault: false,
  );
  final movies = category(
    id: 'movie',
    name: 'Entertainment',
    icon: 'movie',
    isHidden: true,
  );
  final other = category(
    id: 'other',
    name: 'Other',
    icon: 'category',
    isSystem: true,
  );
  final salary = category(
    id: 'salary',
    name: 'Salary',
    icon: 'payments',
    type: CategoryType.income,
  );

  Future<_MockRepository> pumpCategories(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repository = _MockRepository();
    final all = [food, kopi, movies, other, salary];
    when(() => repository.watchCategories())
        .thenAnswer((_) => Stream.value(Right(all)));
    when(() => repository.refreshCategories())
        .thenAnswer((_) async => Right(all));
    final bloc = CategoriesBloc(
      watchCategories: WatchCategoriesUseCase(repository),
      refreshCategories: RefreshCategoriesUseCase(repository),
      setHidden: SetCategoryHiddenUseCase(repository),
      delete: DeleteCategoryUseCase(repository),
    )..add(const CategoriesEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const CategoriesUI()),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('lists each kind of category with its one action', (
    tester,
  ) async {
    // Act
    await pumpCategories(tester);

    // Assert
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Default category'), findsOneWidget);
    expect(find.byTooltip('Hide Food'), findsOneWidget);
    expect(find.text('CUSTOM'), findsOneWidget);
    expect(find.byTooltip('Delete Kopi'), findsOneWidget);
    expect(find.text('HIDDEN'), findsOneWidget);
    expect(find.byTooltip('Show Entertainment'), findsOneWidget);
    expect(find.text('Always kept'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == "Can't be hidden or deleted",
      ),
      findsOneWidget,
    );
    expect(find.text('Salary'), findsNothing);
  });

  testWidgets('the Income tab lists income categories', (tester) async {
    // Arrange
    await pumpCategories(tester);

    // Act
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Food'), findsNothing);
  });

  testWidgets(
    'deleting a category with transactions asks where they go first',
    (tester) async {
      // Arrange
      final repository = await pumpCategories(tester);
      when(() => repository.deleteCategory('kopi')).thenAnswer(
        (_) async => const Left(
          Failure.validation([], code: 'category_has_transactions'),
        ),
      );
      when(() => repository.deleteCategory('kopi', moveTo: 'other'))
          .thenAnswer((_) async => const Right(unit));

      // Act
      await tester.tap(find.byTooltip('Delete Kopi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Move transactions to'), findsOneWidget);

      // Act
      await tester.tap(find.text('Move & delete'));
      await tester.pumpAndSettle();

      // Assert
      verify(() => repository.deleteCategory('kopi', moveTo: 'other'))
          .called(1);
      expect(find.text('“Kopi” deleted.'), findsOneWidget);
    },
  );
}
