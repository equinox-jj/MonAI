part of 'scan_receipt_bloc.dart';

@freezed
sealed class ScanReceiptEvent with _$ScanReceiptEvent {
  /// The camera opened, was refused, or failed.
  const factory ScanReceiptEvent.cameraStatusChanged(CameraStatus status) =
      _CameraStatusChanged;

  const factory ScanReceiptEvent.flashToggled() = _FlashToggled;

  /// The shutter: the screen takes a photo when this is accepted.
  const factory ScanReceiptEvent.captureStarted() = _CaptureStarted;

  /// The camera couldn't take the photo.
  const factory ScanReceiptEvent.captureFailed() = _CaptureFailed;

  /// The camera saved the photo at [path].
  const factory ScanReceiptEvent.photoTaken(String path) = _PhotoTaken;

  /// The gallery's answer; null when nothing was picked.
  const factory ScanReceiptEvent.photoPicked(String? path) = _PhotoPicked;

  /// Back to the camera, from processing or the no-text sheet.
  const factory ScanReceiptEvent.retakeRequested() = _RetakeRequested;
}
