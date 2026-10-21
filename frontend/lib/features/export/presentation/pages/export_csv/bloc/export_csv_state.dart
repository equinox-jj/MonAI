part of 'export_csv_bloc.dart';

@freezed
abstract class ExportCsvState with _$ExportCsvState {
  const factory ExportCsvState({
    required ExportRange range,
    required DateTime currentMonth,
    @Default(CsvDelimiter.comma) CsvDelimiter delimiter,
    @Default(false) bool isExporting,
    ExportFailure? failure,
    ExportedCsv? exported,
  }) = _ExportCsvState;
}

extension ExportCsvStateX on ExportCsvState {
  bool get canMoveFromForward => range.from.isBefore(currentMonth);

  bool get canMoveToForward => range.to.isBefore(currentMonth);
}
