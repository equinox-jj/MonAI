import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/domain/usecase/save_quick_add_draft_usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockCreate extends Mock implements CreateTransactionUseCase {}

void main() {
  test('creates the transaction as an AI quick add', () async {
    // Arrange
    final create = _MockCreate();
    final input = TransactionInput(
      type: TransactionType.expense,
      amount: 25000,
      date: DateTime(2026, 10, 9),
      walletId: 'w1',
      categoryId: 'c1',
      note: 'Kopi',
    );
    registerFallbackValue(input);
    when(() => create(any())).thenAnswer((_) async => Right(transaction()));

    // Act
    await SaveQuickAddDraftUseCase(create)(input);

    // Assert
    verify(() => create(input.copyWith(source: TransactionSource.quickAdd)))
        .called(1);
  });
}
