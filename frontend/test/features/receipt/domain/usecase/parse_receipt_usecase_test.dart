import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements ReceiptRepository {}

class _MockWatchUser extends Mock implements WatchUserUseCase {}

void main() {
  late _MockRepository repository;
  late _MockWatchUser watchUser;
  late ParseReceiptUseCase useCase;

  const draft = ReceiptDraft(amount: 25000, merchant: 'Kopi Kenangan');

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    repository = _MockRepository();
    watchUser = _MockWatchUser();
    useCase = ParseReceiptUseCase(
      repository: repository,
      watchUser: watchUser,
      now: () => DateTime(2026, 10, 9, 20, 3),
    );
    when(
      () => repository.parse(
        any(),
        today: any(named: 'today'),
        timezone: any(named: 'timezone'),
      ),
    ).thenAnswer((_) async => const Right(draft));
  });

  test("sends today and the user's timezone, and gives the draft", () async {
    // Arrange
    when(() => watchUser(any()))
        .thenAnswer((_) => Stream.value(Right<Failure, User?>(user())));

    // Act
    final result = await useCase('TOTAL 25.000');

    // Assert
    expect(result, const Right<Failure, ReceiptDraft>(draft));
    verify(
      () => repository.parse(
        'TOTAL 25.000',
        today: DateTime(2026, 10, 9),
        timezone: 'Asia/Jakarta',
      ),
    ).called(1);
  });

  test('sends at most 5000 characters', () async {
    // Arrange
    when(() => watchUser(any()))
        .thenAnswer((_) => Stream.value(Right<Failure, User?>(user())));

    // Act
    await useCase('a' * 6000);

    // Assert
    verify(
      () => repository.parse(
        'a' * ParseReceiptUseCase.maxTextLength,
        today: any(named: 'today'),
        timezone: any(named: 'timezone'),
      ),
    ).called(1);
  });

  test('uses UTC when the user is not cached yet', () async {
    // Arrange
    when(() => watchUser(any()))
        .thenAnswer((_) => Stream.value(const Right<Failure, User?>(null)));

    // Act
    await useCase('TOTAL 25.000');

    // Assert
    verify(
      () => repository.parse(
        any(),
        today: any(named: 'today'),
        timezone: 'UTC',
      ),
    ).called(1);
  });

  test('uses UTC when the user cannot be read', () async {
    // Arrange
    when(() => watchUser(any())).thenAnswer(
      (_) => Stream.value(const Left<Failure, User?>(Failure.cache())),
    );

    // Act
    await useCase('TOTAL 25.000');

    // Assert
    verify(
      () => repository.parse(
        any(),
        today: any(named: 'today'),
        timezone: 'UTC',
      ),
    ).called(1);
  });

  test('passes a failure through', () async {
    // Arrange
    when(() => watchUser(any()))
        .thenAnswer((_) => Stream.value(Right<Failure, User?>(user())));
    when(
      () => repository.parse(
        any(),
        today: any(named: 'today'),
        timezone: any(named: 'timezone'),
      ),
    ).thenAnswer((_) async => const Left(Failure.serviceUnavailable()));

    // Act
    final result = await useCase('TOTAL 25.000');

    // Assert
    expect(
      result,
      const Left<Failure, ReceiptDraft>(Failure.serviceUnavailable()),
    );
  });
}
