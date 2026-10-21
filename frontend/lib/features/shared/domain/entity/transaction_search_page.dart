import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';

part 'transaction_search_page.freezed.dart';

@freezed
abstract class TransactionSearchPage with _$TransactionSearchPage {
  const factory TransactionSearchPage({
    required List<Transaction> items,
    String? nextCursor,
  }) = _TransactionSearchPage;

  const TransactionSearchPage._();

  bool get hasMore => nextCursor != null;
}
