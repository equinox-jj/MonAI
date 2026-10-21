import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';

/// Where an export's transactions come from and where its file goes.
abstract class ExportRepository {
  /// Every transaction of [month] (the first of the month) from the server,
  /// page by page; each page is cached too.
  Future<Either<Failure, List<Transaction>>> fetchMonth(DateTime month);

  /// Every cached transaction dated from [from] to [to], both included.
  Future<Either<Failure, List<Transaction>>> cachedBetween(
    DateTime from,
    DateTime to,
  );

  /// Writes [content] to a file named [name] that can be shared, replacing
  /// earlier exports; gives its path.
  Future<Either<Failure, String>> writeFile(String name, String content);

  /// The name of the separator last exported with, or null.
  Future<Either<Failure, String?>> savedDelimiter();

  /// Remembers the separator by [name] for the next export.
  Future<Either<Failure, Unit>> saveDelimiter(String name);
}
