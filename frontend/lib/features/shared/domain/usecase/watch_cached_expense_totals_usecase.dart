import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';

class WatchCachedExpenseTotalsUseCase
    implements StreamUseCase<Map<DateTime, int>, int> {
  WatchCachedExpenseTotalsUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Stream<Either<Failure, Map<DateTime, int>>> call(int year) =>
      _repository.watchExpenseTotals(year);
}
