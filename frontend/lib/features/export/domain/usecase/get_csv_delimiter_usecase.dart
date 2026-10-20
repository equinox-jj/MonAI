import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/export/domain/repository/export_repository.dart';

/// The separator last exported with; a comma before the first export.
class GetCsvDelimiterUseCase implements UseCase<CsvDelimiter, NoParams> {
  GetCsvDelimiterUseCase(this._repository);

  final ExportRepository _repository;

  @override
  Future<Either<Failure, CsvDelimiter>> call(NoParams params) async {
    final saved = await _repository.savedDelimiter();
    return Right(
      CsvDelimiter.values.asNameMap()[saved.toNullable()] ?? CsvDelimiter.comma,
    );
  }
}
