import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_phase.freezed.dart';

/// Where the scan is: aiming the camera, reading a photo, or a photo
/// without text.
@freezed
sealed class ScanPhase with _$ScanPhase {
  /// The viewfinder, waiting for a photo.
  const factory ScanPhase.camera() = CameraScanPhase;

  /// Reading [photoPath]; [step] is how far it has got.
  const factory ScanPhase.processing({
    required String photoPath,
    required ProcessingStep step,
  }) = ProcessingScanPhase;

  /// No text was found on [photoPath]: retake it or type it in.
  const factory ScanPhase.noText({required String photoPath}) = NoTextScanPhase;
}

/// The steps of reading a receipt.
enum ProcessingStep {
  /// On the phone, offline.
  readingText,

  /// By the AI.
  findingDetails,
}

/// Whether the camera can be used.
enum CameraStatus {
  /// Still opening; the system may be asking for permission.
  opening,
  ready,

  /// The user refused camera access.
  denied,

  /// No camera, or it failed to open.
  unavailable,
}
