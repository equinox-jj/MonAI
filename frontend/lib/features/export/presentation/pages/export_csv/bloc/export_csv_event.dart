part of 'export_csv_bloc.dart';

@freezed
sealed class ExportCsvEvent with _$ExportCsvEvent {
  /// The sheet opened: loads the separator last used.
  const factory ExportCsvEvent.started() = _Started;

  /// The From month moved by [months] (−1 or 1).
  const factory ExportCsvEvent.fromMoved(int months) = _FromMoved;

  /// The To month moved by [months] (−1 or 1).
  const factory ExportCsvEvent.toMoved(int months) = _ToMoved;

  const factory ExportCsvEvent.delimiterPicked(CsvDelimiter delimiter) =
      _DelimiterPicked;

  /// "Export": writes the file, then shares it under [shareTitle].
  const factory ExportCsvEvent.exportRequested({required String shareTitle}) =
      _ExportRequested;
}
