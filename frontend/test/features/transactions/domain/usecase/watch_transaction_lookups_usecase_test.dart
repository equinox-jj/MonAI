import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockCategories extends Mock implements WatchCategoriesUseCase {}

class _MockWallets extends Mock implements WatchAllWalletsUseCase {}

void main() {
  late _MockCategories categories;
  late _MockWallets wallets;
  late WatchTransactionLookupsUseCase useCase;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    categories = _MockCategories();
    wallets = _MockWallets();
    useCase = WatchTransactionLookupsUseCase(
      categories: categories,
      wallets: wallets,
    );
  });

  test('names categories and wallets, hidden and archived ones too', () async {
    // Arrange
    when(() => categories(any())).thenAnswer(
      (_) => Stream.value(
        Right([category(), category(id: 'c2', name: 'Old', isHidden: true)]),
      ),
    );
    when(() => wallets(any())).thenAnswer(
      (_) => Stream.value(
        Right([wallet(), wallet(id: 'w2', name: 'OVO', isArchived: true)]),
      ),
    );

    // Act
    final result = await useCase(const NoParams()).first;

    // Assert
    final lookups = result.getRight().toNullable()!;
    expect(lookups.category('c2')?.name, 'Old');
    expect(lookups.wallet('w2')?.name, 'OVO');
    expect(lookups.visibleCategories.map((c) => c.id), ['c1']);
    expect(lookups.activeWallets.map((w) => w.id), ['w1']);
    expect(lookups.allWallets.map((w) => w.id), ['w1', 'w2']);
  });

  test('passes on a failed read', () async {
    // Arrange
    when(() => categories(any()))
        .thenAnswer((_) => Stream.value(const Left(Failure.cache())));
    when(() => wallets(any())).thenAnswer((_) => Stream.value(const Right([])));

    // Act
    final result = await useCase(const NoParams()).first;

    // Assert
    expect(result.isLeft(), isTrue);
  });
}
