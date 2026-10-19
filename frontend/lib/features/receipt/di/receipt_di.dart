import 'package:monai/core/di/injector.dart';
import 'package:monai/features/receipt/data/repository/receipt_repository_impl.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/receipt/domain/usecase/read_receipt_text_usecase.dart';

class ReceiptDI {
  ReceiptDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<ReceiptRepository>(
        () => ReceiptRepositoryImpl(scanner: sl()),
      )
      ..registerFactory(() => ReadReceiptTextUseCase(sl()));
  }
}
