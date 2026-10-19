import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/transactions/domain/validation/search_query.dart';

/// One page of server search over a month's notes and merchants. Blank text
/// finds nothing without calling the server.
class SearchTransactionsUseCase
    implements UseCase<TransactionSearchPage, SearchTransactionsParams> {
  SearchTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, TransactionSearchPage>> call(
    SearchTransactionsParams params,
  ) async {
    final query = params.query.normalizedSearch;
    if (query.isEmpty) return const Right(TransactionSearchPage(items: []));
    return _repository.searchTransactions(
      query,
      month: params.month,
      filter: params.filter,
      cursor: params.cursor,
    );
  }
}

/// The search as typed, the month (the first of the month) to search, and
/// the cursor of the page after the first.
class SearchTransactionsParams {
  const SearchTransactionsParams({
    required this.query,
    required this.month,
    this.filter = const TransactionFilter(),
    this.cursor,
  });

  final String query;
  final DateTime month;
  final TransactionFilter filter;
  final String? cursor;
}
