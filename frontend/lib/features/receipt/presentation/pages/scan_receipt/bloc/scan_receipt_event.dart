part of 'scan_receipt_bloc.dart';

@freezed
sealed class ScanReceiptEvent with _$ScanReceiptEvent {
  const factory ScanReceiptEvent.cameraStatusChanged(CameraStatus status) =
      _CameraStatusChanged;

  const factory ScanReceiptEvent.flashToggled() = _FlashToggled;
  const factory ScanReceiptEvent.captureStarted() = _CaptureStarted;
  const factory ScanReceiptEvent.captureFailed() = _CaptureFailed;
  const factory ScanReceiptEvent.photoTaken(String path) = _PhotoTaken;
  const factory ScanReceiptEvent.photoPicked(String? path) = _PhotoPicked;
  const factory ScanReceiptEvent.retakeRequested() = _RetakeRequested;
}
