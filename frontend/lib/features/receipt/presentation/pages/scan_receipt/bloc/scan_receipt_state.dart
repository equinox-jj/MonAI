part of 'scan_receipt_bloc.dart';

@freezed
abstract class ScanReceiptState with _$ScanReceiptState {
  const factory ScanReceiptState({
    @Default(ScanPhase.camera()) ScanPhase phase,
    @Default(CameraStatus.opening) CameraStatus camera,
    @Default(false) bool flashOn,

    /// A photo is being taken; the shutter waits.
    @Default(false) bool isCapturing,

    /// Taking the photo failed; shown once as a snackbar.
    @Default(false) bool captureFailed,

    /// Set once a photo was read; the screen opens the review.
    ReceiptReviewArgs? review,
  }) = _ScanReceiptState;
}

extension ScanReceiptStateX on ScanReceiptState {
  /// Whether the shutter takes a photo now.
  bool get canCapture =>
      camera == CameraStatus.ready && phase is CameraScanPhase && !isCapturing;
}
