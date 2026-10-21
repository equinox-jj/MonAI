import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';

abstract class ExportRepository {
  Future<Either<Failure, List<Transaction>>> fetchMonth(DateTime month);

  Future<Either<Failure, List<Transaction>>> cachedBetween(
    DateTime from,
    DateTime to,
  );

  Future<Either<Failure, String>> writeFile(String name, String content);

  Future<Either<Failure, String?>> savedDelimiter();

  Future<Either<Failure, Unit>> saveDelimiter(String name);
}
