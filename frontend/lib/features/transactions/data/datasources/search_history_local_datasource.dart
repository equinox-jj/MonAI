import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/storage/app_preferences.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> recentSearches();

  Future<void> addRecentSearch(String query);
}

class SearchHistoryLocalDataSourceImpl extends SearchHistoryLocalDataSource
    with BaseLocalDataSource {
  SearchHistoryLocalDataSourceImpl({required this._preferences});

  final AppPreferences _preferences;

  @override
  Future<List<String>> recentSearches() =>
      safeCacheCall(_preferences.recentSearches);

  @override
  Future<void> addRecentSearch(String query) =>
      safeCacheCall(() => _preferences.addRecentSearch(query));
}
