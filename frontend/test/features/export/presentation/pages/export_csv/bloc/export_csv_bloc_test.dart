import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/services/file_share_service.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/export/domain/usecase/export_transactions_csv_usecase.dart';
import 'package:monai/features/export/domain/usecase/get_csv_delimiter_usecase.dart';
import 'package:monai/features/export/presentation/model/export_failure.dart';
import 'package:monai/features/export/presentation/pages/export_csv/bloc/export_csv_bloc.dart';

class _MockExport extends Mock implements ExportTransactionsCsvUseCase {}

class _MockGetDelimiter extends Mock implements GetCsvDelimiterUseCase {}

class _MockShare extends Mock implements FileShareService {}

final _now = DateTime(2026, 10, 21);
const _exported = ExportedCsv(
  path: '/tmp/exports/a.csv',
  rowCount: 3,
  isComplete: true,
);

void main() {
  late _MockExport export;
  late _MockGetDelimiter getDelimiter;
  late _MockShare share;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      ExportCsvParams(
        range: ExportRange.thisMonth(_now),
        delimiter: CsvDelimiter.comma,
      ),
    );
  });

  setUp(() {
    export = _MockExport();
    getDelimiter = _MockGetDelimiter();
    share = _MockShare();
    when(() => getDelimiter(any()))
        .thenAnswer((_) async => const Right(CsvDelimiter.semicolon));
    when(
      () => share.shareFile(
        any(),
        mimeType: any(named: 'mimeType'),
        title: any(named: 'title'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<ExportCsvBloc> started() async {
    final bloc = ExportCsvBloc(
      export: export,
      getDelimiter: getDelimiter,
      share: share,
      now: () => _now,
    )..add(const ExportCsvEvent.started());
    await Future<void>.delayed(Duration.zero);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(ExportCsvBloc bloc, ExportCsvEvent event) async {
    bloc.add(event);
    await Future<void>.delayed(Duration.zero);
  }

  test('starts on this month with the saved separator', () async {
    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.range, ExportRange.thisMonth(_now));
    expect(bloc.state.delimiter, CsvDelimiter.semicolon);
    expect(bloc.state.canMoveFromForward, isFalse);
    expect(bloc.state.canMoveToForward, isFalse);
  });

  test('moving From back widens the range', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const ExportCsvEvent.fromMoved(-2));

    // Assert
    expect(bloc.state.range.from, DateTime(2026, 8));
    expect(bloc.state.canMoveFromForward, isTrue);
  });

  test('exports with the choices, shares the file and is done', () async {
    // Arrange
    when(() => export(any())).thenAnswer((_) async => const Right(_exported));
    final bloc = await started();
    await send(bloc, const ExportCsvEvent.delimiterPicked(CsvDelimiter.comma));

    // Act
    await send(bloc, const ExportCsvEvent.exportRequested(shareTitle: 'Share'));

    // Assert
    final params =
        verify(() => export(captureAny())).captured.single as ExportCsvParams;
    expect(params.delimiter, CsvDelimiter.comma);
    verify(
      () => share.shareFile(
        '/tmp/exports/a.csv',
        mimeType: 'text/csv',
        title: 'Share',
      ),
    ).called(1);
    expect(bloc.state.exported, _exported);
    expect(bloc.state.isExporting, isFalse);
  });

  test('nothing to export shows why and stays open', () async {
    // Arrange
    when(() => export(any())).thenAnswer(
      (_) async => const Left(
        Failure.notFound(code: ExportTransactionsCsvUseCase.noTransactions),
      ),
    );
    final bloc = await started();

    // Act
    await send(bloc, const ExportCsvEvent.exportRequested(shareTitle: 'Share'));

    // Assert
    expect(bloc.state.failure, ExportFailure.empty);
    expect(bloc.state.exported, isNull);
    verifyNever(
      () => share.shareFile(
        any(),
        mimeType: any(named: 'mimeType'),
        title: any(named: 'title'),
      ),
    );
  });

  test('a change clears the failure', () async {
    // Arrange
    when(() => export(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = await started();
    await send(bloc, const ExportCsvEvent.exportRequested(shareTitle: 'Share'));

    // Act
    await send(bloc, const ExportCsvEvent.fromMoved(-1));

    // Assert
    expect(bloc.state.failure, isNull);
  });
}
