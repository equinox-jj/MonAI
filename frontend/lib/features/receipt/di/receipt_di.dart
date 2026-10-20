import 'package:monai/core/di/injector.dart';
import 'package:monai/features/receipt/data/datasources/receipt_remote_datasource.dart';
import 'package:monai/features/receipt/data/repository/receipt_repository_impl.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/receipt/domain/usecase/create_receipt_transaction_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/read_receipt_text_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/bloc/scan_receipt_bloc.dart';

class ReceiptDI {
  ReceiptDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<ReceiptRemoteDataSource>(
        () => ReceiptRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<ReceiptRepository>(
        () => ReceiptRepositoryImpl(
          scanner: sl(),
          compressor: sl(),
          remote: sl(),
        ),
      )
      ..registerFactory(() => ReadReceiptTextUseCase(sl()))
      ..registerFactory(
        () => ParseReceiptUseCase(repository: sl(), watchUser: sl()),
      )
      ..registerFactory(
        () => CreateReceiptTransactionUseCase(
          repository: sl(),
          upload: sl(),
          create: sl(),
        ),
      )
      ..registerFactory(() => ScanReceiptBloc(readText: sl(), parse: sl()))
      ..registerFactoryParam<ReceiptReviewBloc, ReceiptReviewArgs, void>(
        (args, _) => ReceiptReviewBloc(
          args: args,
          save: sl(),
          parse: sl(),
          watchWallets: sl(),
          watchCategories: sl(),
        ),
      );
  }
}
