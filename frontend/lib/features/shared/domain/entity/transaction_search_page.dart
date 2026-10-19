import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';

part 'transaction_search_page.freezed.dart';

/// One page of server search results; [nextCursor] is null on the last page.
@freezed
abstract class TransactionSearchPage with _$TransactionSearchPage {
  const factory TransactionSearchPage({
    required List<Transaction> items,
    String? nextCursor,
  }) = _TransactionSearchPage;

  const TransactionSearchPage._();

  /// Whether more results follow.
  bool get hasMore => nextCursor != null;
}
