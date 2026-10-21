import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';

/// The transaction searches made on this device, newest first.
abstract class SearchHistoryRepository {
  /// The last searches, newest first.
  Future<Either<Failure, List<String>>> recentSearches();

  /// Remembers [query] and gives the updated list.
  Future<Either<Failure, List<String>>> addRecentSearch(String query);
}
