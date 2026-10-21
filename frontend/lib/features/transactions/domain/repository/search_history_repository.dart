import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';

abstract class SearchHistoryRepository {
  Future<Either<Failure, List<String>>> recentSearches();

  Future<Either<Failure, List<String>>> addRecentSearch(String query);
}
