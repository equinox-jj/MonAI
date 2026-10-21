import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/transaction_dao.dart';
import 'package:monai/core/model/transaction_type.dart';

abstract class QuickaddLocalDataSource {
  /// [text] is lowercase and trimmed; null when the user never did.
  Future<String?> categoryForText(String text, TransactionType type);
}

class QuickaddLocalDataSourceImpl extends QuickaddLocalDataSource
    with BaseLocalDataSource {
  QuickaddLocalDataSourceImpl({required this._dao});

  final TransactionDao _dao;

  @override
  Future<String?> categoryForText(String text, TransactionType type) =>
      safeCacheCall(() => _dao.latestCategoryForText(text, type));
}
