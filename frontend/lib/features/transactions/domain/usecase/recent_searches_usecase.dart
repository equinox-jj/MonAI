import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/transactions/domain/repository/search_history_repository.dart';
import 'package:monai/features/transactions/domain/validation/search_query.dart';

class GetRecentSearchesUseCase implements UseCase<List<String>, NoParams> {
  GetRecentSearchesUseCase(this._repository);

  final SearchHistoryRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) =>
      _repository.recentSearches();
}

/// Cleans the query up like the search itself. Blank text changes nothing.
class AddRecentSearchUseCase implements UseCase<List<String>, String> {
  AddRecentSearchUseCase(this._repository);

  final SearchHistoryRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call(String query) {
    final normalized = query.normalizedSearch;
    if (normalized.isEmpty) return _repository.recentSearches();
    return _repository.addRecentSearch(normalized);
  }
}
