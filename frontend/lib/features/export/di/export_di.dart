import 'package:monai/core/app/injector.dart';
import 'package:monai/features/export/data/datasources/export_local_datasource.dart';
import 'package:monai/features/export/data/repository/export_repository_impl.dart';
import 'package:monai/features/export/domain/repository/export_repository.dart';
import 'package:monai/features/export/domain/usecase/export_transactions_csv_usecase.dart';
import 'package:monai/features/export/domain/usecase/get_csv_delimiter_usecase.dart';
import 'package:monai/features/export/presentation/pages/export_csv/bloc/export_csv_bloc.dart';

class ExportDI {
  ExportDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<ExportLocalDataSource>(
        () => ExportLocalDataSourceImpl(dao: sl(), preferences: sl()),
      )
      ..registerLazySingleton<ExportRepository>(
        () => ExportRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerFactory(
        () => ExportTransactionsCsvUseCase(
          repository: sl(),
          wallets: sl(),
          categories: sl(),
        ),
      )
      ..registerFactory(() => GetCsvDelimiterUseCase(sl()))
      ..registerFactory(
        () => ExportCsvBloc(export: sl(), getDelimiter: sl(), share: sl()),
      );
  }
}
