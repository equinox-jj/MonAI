part of 'export_csv_bloc.dart';

@freezed
sealed class ExportCsvEvent with _$ExportCsvEvent {
  const factory ExportCsvEvent.started() = _Started;
  const factory ExportCsvEvent.fromMoved(int months) = _FromMoved;
  const factory ExportCsvEvent.toMoved(int months) = _ToMoved;

  const factory ExportCsvEvent.delimiterPicked(CsvDelimiter delimiter) =
      _DelimiterPicked;

  const factory ExportCsvEvent.exportRequested({required String shareTitle}) =
      _ExportRequested;
}
