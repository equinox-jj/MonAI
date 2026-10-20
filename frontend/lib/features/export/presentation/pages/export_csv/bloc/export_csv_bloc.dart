import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/services/file_share_service.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/export/domain/usecase/export_transactions_csv_usecase.dart';
import 'package:monai/features/export/domain/usecase/get_csv_delimiter_usecase.dart';
import 'package:monai/features/export/presentation/model/export_failure.dart';

part 'export_csv_bloc.freezed.dart';
part 'export_csv_event.dart';
part 'export_csv_state.dart';

/// Picks the months and the separator, writes the CSV and hands it to the
/// share sheet. The range starts on the current month, covers at most 12
/// months and never goes past this month.
class ExportCsvBloc extends Bloc<ExportCsvEvent, ExportCsvState> {
  /// [now] is the clock; tests pass a fixed one.
  ExportCsvBloc({
    required this._export,
    required this._getDelimiter,
    required this._share,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(_initialState((now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_FromMoved>(_onFromMoved);
    on<_ToMoved>(_onToMoved);
    on<_DelimiterPicked>(_onDelimiterPicked);
    on<_ExportRequested>(_onExportRequested);
  }

  static const _mimeType = 'text/csv';

  final ExportTransactionsCsvUseCase _export;
  final GetCsvDelimiterUseCase _getDelimiter;
  final FileShareService _share;
  final DateTime Function() _now;

  static ExportCsvState _initialState(DateTime now) => ExportCsvState(
    range: ExportRange.thisMonth(now),
    currentMonth: DateTime(now.year, now.month),
  );

  Future<void> _onStarted(_Started event, Emitter<ExportCsvState> emit) async {
    final result = await _getDelimiter(const NoParams());
    emit(state.copyWith(delimiter: result.getOrElse((_) => state.delimiter)));
  }

  void _onFromMoved(_FromMoved event, Emitter<ExportCsvState> emit) => emit(
    state.copyWith(
      range: state.range.movedFrom(event.months, _now()),
      failure: null,
    ),
  );

  void _onToMoved(_ToMoved event, Emitter<ExportCsvState> emit) => emit(
    state.copyWith(
      range: state.range.movedTo(event.months, _now()),
      failure: null,
    ),
  );

  void _onDelimiterPicked(
    _DelimiterPicked event,
    Emitter<ExportCsvState> emit,
  ) => emit(state.copyWith(delimiter: event.delimiter, failure: null));

  Future<void> _onExportRequested(
    _ExportRequested event,
    Emitter<ExportCsvState> emit,
  ) async {
    if (state.isExporting || state.exported != null) return;
    emit(state.copyWith(isExporting: true, failure: null));
    final result = await _export(
      ExportCsvParams(range: state.range, delimiter: state.delimiter),
    );
    switch (result) {
      case Right(value: final exported):
        try {
          await _share.shareFile(
            exported.path,
            mimeType: _mimeType,
            title: event.shareTitle,
          );
        } on Object {
          emit(
            state.copyWith(
              isExporting: false,
              failure: ExportFailure.unexpected,
            ),
          );
          return;
        }
        emit(state.copyWith(isExporting: false, exported: exported));
      case Left(value: final failure):
        emit(
          state.copyWith(
            isExporting: false,
            failure: ExportFailure.of(failure),
          ),
        );
    }
  }
}
