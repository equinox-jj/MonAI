import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/services/image_compressor_service.dart';
import 'package:monai/core/data/services/receipt_scanner_service.dart';
import 'package:monai/features/receipt/data/datasources/receipt_remote_datasource.dart';
import 'package:monai/features/receipt/data/mapper/receipt_mapper.dart';
import 'package:monai/features/receipt/data/model/parse_receipt_request.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';

class ReceiptRepositoryImpl extends ReceiptRepository with BaseRepository {
  ReceiptRepositoryImpl({
    required this._scanner,
    required this._compressor,
    required this._remote,
  });

  final ReceiptScannerService _scanner;
  final ImageCompressorService _compressor;
  final ReceiptRemoteDataSource _remote;

  @override
  Future<Either<Failure, String?>> readText(String imagePath) =>
      safeCall(() => _scanner.readText(imagePath));

  @override
  Future<Either<Failure, Uint8List>> compressPhoto(String imagePath) =>
      safeCall(() => _compressor.compressForUpload(imagePath));

  @override
  Future<Either<Failure, ReceiptDraft>> parse(
    String ocrText, {
    required DateTime today,
    required String timezone,
  }) => safeCall(() async {
    final response = await _remote.parseReceipt(
      ParseReceiptRequest(
        ocrText: ocrText,
        today: formatApiDate(today),
        timezone: timezone,
      ),
    );
    return requireField(response.data?.draft).toEntity();
  });
}
