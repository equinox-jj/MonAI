part of 'scan_receipt_bloc.dart';

@freezed
abstract class ScanReceiptState with _$ScanReceiptState {
  const factory ScanReceiptState({
    @Default(ScanPhase.camera()) ScanPhase phase,
    @Default(CameraStatus.opening) CameraStatus camera,
    @Default(false) bool flashOn,
    @Default(false) bool isCapturing,
    @Default(false) bool captureFailed,
    ReceiptReviewArgs? review,
  }) = _ScanReceiptState;
}

extension ScanReceiptStateX on ScanReceiptState {
  bool get canCapture =>
      camera == CameraStatus.ready && phase is CameraScanPhase && !isCapturing;
}
