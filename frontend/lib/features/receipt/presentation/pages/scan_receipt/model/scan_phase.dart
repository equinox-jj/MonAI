import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_phase.freezed.dart';

@freezed
sealed class ScanPhase with _$ScanPhase {
  const factory ScanPhase.camera() = CameraScanPhase;

  const factory ScanPhase.processing({
    required String photoPath,
    required ProcessingStep step,
  }) = ProcessingScanPhase;

  const factory ScanPhase.noText({required String photoPath}) = NoTextScanPhase;
}

enum ProcessingStep { readingText, findingDetails }

enum CameraStatus { opening, ready, denied, unavailable }
