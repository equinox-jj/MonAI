import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/transactions/domain/validation/search_query.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';

extension SearchStateX on SearchState {
  DateTime get currentMonth => monthOf(today);

  bool get hasQuery => query.normalizedSearch.isNotEmpty;

  bool get hasFilter => filter != const TransactionFilter();

  bool get hasMore => allMonths ? results.length >= limit : nextCursor != null;

  int get net => results.fold(
    0,
    (sum, t) => switch (t.type) {
      .income => sum + t.amount,
      .expense => sum - t.amount,
      .transfer => sum,
    },
  );
}
