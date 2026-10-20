import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/read_receipt_text_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';

part 'scan_receipt_bloc.freezed.dart';
part 'scan_receipt_event.dart';
part 'scan_receipt_state.dart';

/// Takes or picks a receipt photo, reads its text on the phone, then asks
/// the AI for a draft. No text means retake or type it in; an AI failure
/// still opens the review, empty, so the photo isn't lost. The camera
/// itself belongs to the screen, which reports what it does.
class ScanReceiptBloc extends Bloc<ScanReceiptEvent, ScanReceiptState> {
  ScanReceiptBloc({required this._readText, required this._parse})
    : super(const ScanReceiptState()) {
    on<_CameraStatusChanged>(_onCameraStatusChanged);
    on<_FlashToggled>(_onFlashToggled);
    on<_CaptureStarted>(_onCaptureStarted);
    on<_CaptureFailed>(_onCaptureFailed);
    on<_PhotoTaken>(_onPhotoTaken);
    on<_PhotoPicked>(_onPhotoPicked);
    on<_RetakeRequested>(_onRetakeRequested);
  }

  final ReadReceiptTextUseCase _readText;
  final ParseReceiptUseCase _parse;

  /// Bumped by each new photo and by retake, so a reading that was left
  /// behind can't change the screen when it finishes.
  int _run = 0;

  void _onCameraStatusChanged(
    _CameraStatusChanged event,
    Emitter<ScanReceiptState> emit,
  ) => emit(state.copyWith(camera: event.status));

  void _onFlashToggled(_FlashToggled event, Emitter<ScanReceiptState> emit) =>
      emit(state.copyWith(flashOn: !state.flashOn));

  void _onCaptureStarted(
    _CaptureStarted event,
    Emitter<ScanReceiptState> emit,
  ) {
    if (!state.canCapture) return;
    emit(state.copyWith(isCapturing: true));
  }

  void _onCaptureFailed(_CaptureFailed event, Emitter<ScanReceiptState> emit) {
    emit(state.copyWith(isCapturing: false, captureFailed: true));
    emit(state.copyWith(captureFailed: false));
  }

  Future<void> _onPhotoTaken(
    _PhotoTaken event,
    Emitter<ScanReceiptState> emit,
  ) {
    emit(state.copyWith(isCapturing: false));
    return _process(event.path, emit);
  }

  Future<void> _onPhotoPicked(
    _PhotoPicked event,
    Emitter<ScanReceiptState> emit,
  ) async {
    if (event.path case final path?) await _process(path, emit);
  }

  void _onRetakeRequested(
    _RetakeRequested event,
    Emitter<ScanReceiptState> emit,
  ) {
    _run++;
    emit(state.copyWith(phase: const ScanPhase.camera()));
  }

  Future<void> _process(String path, Emitter<ScanReceiptState> emit) async {
    final run = ++_run;
    emit(
      state.copyWith(
        phase: ScanPhase.processing(
          photoPath: path,
          step: ProcessingStep.readingText,
        ),
      ),
    );
    final text = (await _readText(path)).toNullable();
    if (run != _run) return;
    if (text == null) {
      emit(state.copyWith(phase: ScanPhase.noText(photoPath: path)));
      return;
    }
    emit(
      state.copyWith(
        phase: ScanPhase.processing(
          photoPath: path,
          step: ProcessingStep.findingDetails,
        ),
      ),
    );
    final draft = await _parse(text);
    if (run != _run) return;
    final review = switch (draft) {
      Right(:final value) => ReceiptReviewArgs(
        photoPath: path,
        ocrText: text,
        draft: value,
      ),
      Left(value: final failure) => ReceiptReviewArgs(
        photoPath: path,
        ocrText: text,
        draft: ReceiptDraft.empty,
        aiFailure: ReceiptAiFailure.of(failure),
      ),
    };
    // Coming back from the review starts a new scan.
    emit(state.copyWith(phase: const ScanPhase.camera(), review: review));
    emit(state.copyWith(review: null));
  }
}
