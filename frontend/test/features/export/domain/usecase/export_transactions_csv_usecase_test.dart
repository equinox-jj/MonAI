import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/export/domain/repository/export_repository.dart';
import 'package:monai/features/export/domain/usecase/export_transactions_csv_usecase.dart';
import 'package:monai/features/export/domain/usecase/get_csv_delimiter_usecase.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements ExportRepository {}

class _MockWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockCategories extends Mock implements WatchCategoriesUseCase {}

final _now = DateTime(2026, 10, 21);

void main() {
  late _MockRepository repository;
  late _MockWallets wallets;
  late _MockCategories categories;
  late ExportTransactionsCsvUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    repository = _MockRepository();
    wallets = _MockWallets();
    categories = _MockCategories();
    useCase = ExportTransactionsCsvUseCase(
      repository: repository,
      wallets: wallets,
      categories: categories,
      now: () => _now,
    );
    when(
      () => wallets(any()),
    ).thenAnswer((_) => Stream.value(Right<Failure, List<Wallet>>([wallet()])));
    when(() => categories(any())).thenAnswer(
      (_) => Stream.value(Right<Failure, List<Category>>([category()])),
    );
    when(() => repository.saveDelimiter(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => repository.writeFile(any(), any()))
        .thenAnswer((_) async => const Right('/tmp/exports/file.csv'));
  });

  ExportCsvParams params(ExportRange range) =>
      ExportCsvParams(range: range, delimiter: CsvDelimiter.semicolon);

  test(
    'fetches every month, writes the file and remembers the separator',
    () async {
      // Arrange
      final range = ExportRange(DateTime(2026, 9), DateTime(2026, 10));
      when(() => repository.fetchMonth(DateTime(2026, 9))).thenAnswer(
        (_) async => Right([transaction(id: 't1', date: DateTime(2026, 9, 3))]),
      );
      when(() => repository.fetchMonth(DateTime(2026, 10))).thenAnswer(
        (_) async =>
            Right([transaction(id: 't2', date: DateTime(2026, 10, 3))]),
      );

      // Act
      final result = await useCase(params(range));

      // Assert
      expect(
        result,
        const Right<Failure, ExportedCsv>(
          ExportedCsv(
            path: '/tmp/exports/file.csv',
            rowCount: 2,
            isComplete: true,
          ),
        ),
      );
      final captured = verify(
        () => repository.writeFile(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'monai-transactions-2026-09_2026-10.csv');
      final csv = captured[1] as String;
      expect(csv, contains('Date;Type'));
      expect(csv, contains(';Cash;;Food;'));
      verify(() => repository.saveDelimiter('semicolon')).called(1);
    },
  );

  test('offline, exports the cached transactions as incomplete', () async {
    // Arrange
    final range = ExportRange.thisMonth(_now);
    when(() => repository.fetchMonth(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    when(() => repository.cachedBetween(any(), any()))
        .thenAnswer((_) async => Right([transaction()]));

    // Act
    final result = await useCase(params(range));

    // Assert
    expect(result.getOrElse((_) => throw StateError('')).isComplete, isFalse);
    verify(
      () =>
          repository.cachedBetween(DateTime(2026, 10), DateTime(2026, 10, 31)),
    ).called(1);
  });

  test('offline with nothing cached fails as offline', () async {
    // Arrange
    when(() => repository.fetchMonth(any()))
        .thenAnswer((_) async => const Left(Failure.timeout()));
    when(() => repository.cachedBetween(any(), any()))
        .thenAnswer((_) async => const Right([]));

    // Act
    final result = await useCase(params(ExportRange.thisMonth(_now)));

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });

  test('empty months fail with no transactions', () async {
    // Arrange
    when(() => repository.fetchMonth(any()))
        .thenAnswer((_) async => const Right([]));

    // Act
    final result = await useCase(params(ExportRange.thisMonth(_now)));

    // Assert
    expect(
      result.getLeft().toNullable()?.code,
      ExportTransactionsCsvUseCase.noTransactions,
    );
    verifyNever(() => repository.writeFile(any(), any()));
  });

  test('a range past this month fails without fetching', () async {
    // Arrange
    final future = ExportRange(DateTime(2026, 11), DateTime(2026, 11));

    // Act
    final result = await useCase(params(future));

    // Assert
    expect(
      result.getLeft().toNullable()?.code,
      ExportTransactionsCsvUseCase.invalidRange,
    );
    verifyNever(() => repository.fetchMonth(any()));
  });

  test('names a one-month file by its month', () {
    // Act
    final name = ExportTransactionsCsvUseCase.fileName(
      ExportRange.thisMonth(_now),
    );

    // Assert
    expect(name, 'monai-transactions-2026-10.csv');
  });

  group('GetCsvDelimiterUseCase', () {
    test('gives the saved separator, a comma before any', () async {
      // Arrange
      when(() => repository.savedDelimiter())
          .thenAnswer((_) async => const Right(null));
      final none = await GetCsvDelimiterUseCase(repository)(const NoParams());
      when(() => repository.savedDelimiter())
          .thenAnswer((_) async => const Right('semicolon'));

      // Act
      final saved = await GetCsvDelimiterUseCase(repository)(const NoParams());

      // Assert
      expect(none, const Right<Failure, CsvDelimiter>(CsvDelimiter.comma));
      expect(saved, const Right<Failure, CsvDelimiter>(CsvDelimiter.semicolon));
    });
  });
}
