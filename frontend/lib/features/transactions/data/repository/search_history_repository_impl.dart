import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/transactions/data/datasources/search_history_local_datasource.dart';
import 'package:monai/features/transactions/domain/repository/search_history_repository.dart';

class SearchHistoryRepositoryImpl extends SearchHistoryRepository
    with BaseRepository {
  SearchHistoryRepositoryImpl({required this._local});

  final SearchHistoryLocalDataSource _local;

  @override
  Future<Either<Failure, List<String>>> recentSearches() =>
      safeCall(_local.recentSearches);

  @override
  Future<Either<Failure, List<String>>> addRecentSearch(String query) =>
      safeCall(() async {
        await _local.addRecentSearch(query);
        return _local.recentSearches();
      });
}
