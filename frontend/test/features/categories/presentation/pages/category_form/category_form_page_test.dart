import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/categories/domain/usecase/create_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/find_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/category_form_page.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements CategoryRepository {}

void main() {
  final kopi = category(
    id: 'kopi',
    name: 'Kopi',
    icon: 'local_cafe',
    isDefault: false,
  );

  setUpAll(
    () => registerFallbackValue(
      const CategoryInput(name: '', type: CategoryType.expense),
    ),
  );

  Future<_MockRepository> pumpForm(
    WidgetTester tester,
    CategoryFormMode mode,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repository = _MockRepository();
    when(() => repository.findCategory('kopi'))
        .thenAnswer((_) async => Right(kopi));
    final bloc = CategoryFormBloc(
      mode: mode,
      find: FindCategoryUseCase(repository),
      create: CreateCategoryUseCase(repository),
      update: UpdateCategoryUseCase(repository),
    )..add(const CategoryFormEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const CategoryFormUI()),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('a new category previews its name as it is typed', (
    tester,
  ) async {
    // Arrange
    await pumpForm(tester, const CategoryFormMode.create(CategoryType.income));
    expect(find.text('Income category · 0/30'), findsOneWidget);
    expect(find.text('New category'), findsNWidgets(2));

    // Act
    await tester.enterText(find.byType(TextField), 'Freelance');
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Income category · 9/30'), findsOneWidget);
    expect(find.text('Freelance'), findsNWidgets(2));
    expect(find.text('Delete category'), findsNothing);
  });

  testWidgets('a taken name shows under the field', (tester) async {
    // Arrange
    final repository = await pumpForm(
      tester,
      const CategoryFormMode.create(CategoryType.expense),
    );
    when(() => repository.createCategory(any()))
        .thenAnswer((_) async => const Left(Failure.conflict()));
    await tester.enterText(find.byType(TextField), 'Food');

    // Act
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Assert
    expect(
      find.text('You already have a category with this name.'),
      findsOneWidget,
    );
  });

  testWidgets('editing a custom category fills it and offers delete', (
    tester,
  ) async {
    // Act
    await pumpForm(tester, const CategoryFormMode.edit('kopi'));

    // Assert
    expect(find.text('Edit category'), findsOneWidget);
    expect(find.text('Kopi'), findsNWidgets(2));
    expect(find.text('Delete category'), findsOneWidget);
  });
}
