import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/transactions/domain/validation/search_query.dart';

class WatchCachedSearchUseCase
    implements StreamUseCase<List<Transaction>, CachedSearchParams> {
  WatchCachedSearchUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Either<Failure, List<Transaction>>> call(CachedSearchParams params) {
    final query = params.query.normalizedSearch;
    if (query.isEmpty) return Stream.value(const Right([]));
    return _repository.watchCachedSearch(
      query,
      params.filter,
      limit: params.limit,
    );
  }
}

class CachedSearchParams {
  const CachedSearchParams({
    required this.query,
    required this.limit,
    this.filter = const TransactionFilter(),
  });

  final String query;
  final int limit;
  final TransactionFilter filter;
}
