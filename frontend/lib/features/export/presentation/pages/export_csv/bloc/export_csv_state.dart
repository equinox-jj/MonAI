part of 'export_csv_bloc.dart';

@freezed
abstract class ExportCsvState with _$ExportCsvState {
  const factory ExportCsvState({
    /// The months to export.
    required ExportRange range,

    /// The latest month that can be exported: the current one.
    required DateTime currentMonth,
    @Default(CsvDelimiter.comma) CsvDelimiter delimiter,
    @Default(false) bool isExporting,

    /// Why the last export failed; cleared by any change.
    ExportFailure? failure,

    /// Set once the file was shared; the sheet closes.
    ExportedCsv? exported,
  }) = _ExportCsvState;
}

extension ExportCsvStateX on ExportCsvState {
  bool get canMoveFromForward => range.from.isBefore(currentMonth);

  bool get canMoveToForward => range.to.isBefore(currentMonth);
}
