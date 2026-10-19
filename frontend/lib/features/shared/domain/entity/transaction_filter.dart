import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction_filter.freezed.dart';

/// Narrows a transaction list. [walletId] matches the source or the
/// destination wallet, like the API.
@freezed
abstract class TransactionFilter with _$TransactionFilter {
  const factory TransactionFilter({
    String? walletId,
    String? categoryId,
    TransactionType? type,
  }) = _TransactionFilter;
}
