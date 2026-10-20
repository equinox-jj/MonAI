import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/read_receipt_text_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/bloc/scan_receipt_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';

class _MockReadText extends Mock implements ReadReceiptTextUseCase {}

class _MockParse extends Mock implements ParseReceiptUseCase {}

void main() {
  late _MockReadText readText;
  late _MockParse parse;

  const path = '/tmp/receipt.jpg';
  const draft = ReceiptDraft(amount: 25000, merchant: 'Kopi Kenangan');

  setUp(() {
    readText = _MockReadText();
    parse = _MockParse();
  });

  ScanReceiptBloc build() {
    final bloc = ScanReceiptBloc(readText: readText, parse: parse);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(ScanReceiptBloc bloc, ScanReceiptEvent event) {
    bloc.add(event);
    return Future<void>.delayed(Duration.zero);
  }

  /// Every review the bloc hands over, in order.
  List<ReceiptReviewArgs> reviews(ScanReceiptBloc bloc) {
    final seen = <ReceiptReviewArgs>[];
    final sub = bloc.stream.listen((s) {
      if (s.review case final review?) seen.add(review);
    });
    addTearDown(sub.cancel);
    return seen;
  }

  test('starts on the camera while it opens', () {
    // Arrange
    // (nothing)

    // Act
    final bloc = build();

    // Assert
    expect(bloc.state.phase, const ScanPhase.camera());
    expect(bloc.state.camera, CameraStatus.opening);
    expect(bloc.state.flashOn, isFalse);
  });

  test('follows the camera status and the flash', () async {
    // Arrange
    final bloc = build();

    // Act
    await send(
      bloc,
      const ScanReceiptEvent.cameraStatusChanged(CameraStatus.denied),
    );
    await send(bloc, const ScanReceiptEvent.flashToggled());

    // Assert
    expect(bloc.state.camera, CameraStatus.denied);
    expect(bloc.state.flashOn, isTrue);
  });

  test('a photo with text opens the review with the AI draft', () async {
    // Arrange
    when(() => readText(path)).thenAnswer((_) async => const Right('TOTAL'));
    when(() => parse('TOTAL')).thenAnswer((_) async => const Right(draft));
    final bloc = build();
    final seen = reviews(bloc);

    // Act
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Assert
    expect(seen, [
      const ReceiptReviewArgs(photoPath: path, ocrText: 'TOTAL', draft: draft),
    ]);
    expect(bloc.state.phase, const ScanPhase.camera());
    expect(bloc.state.review, isNull);
  });

  test('shows each processing step', () async {
    // Arrange
    final text = Completer<Either<Failure, String?>>();
    final ai = Completer<Either<Failure, ReceiptDraft>>();
    when(() => readText(path)).thenAnswer((_) => text.future);
    when(() => parse(any())).thenAnswer((_) => ai.future);
    final bloc = build();

    // Act
    await send(bloc, const ScanReceiptEvent.photoTaken(path));
    final reading = bloc.state.phase;
    text.complete(const Right('TOTAL'));
    await Future<void>.delayed(Duration.zero);
    final finding = bloc.state.phase;
    ai.complete(const Right(draft));
    await Future<void>.delayed(Duration.zero);

    // Assert
    expect(
      reading,
      const ScanPhase.processing(
        photoPath: path,
        step: ProcessingStep.readingText,
      ),
    );
    expect(
      finding,
      const ScanPhase.processing(
        photoPath: path,
        step: ProcessingStep.findingDetails,
      ),
    );
  });

  test('a photo without text asks to retake it', () async {
    // Arrange
    when(() => readText(path)).thenAnswer((_) async => const Right(null));
    final bloc = build();

    // Act
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Assert
    expect(bloc.state.phase, const ScanPhase.noText(photoPath: path));
    verifyNever(() => parse(any()));
  });

  test('a photo that cannot be read asks to retake it too', () async {
    // Arrange
    when(() => readText(path))
        .thenAnswer((_) async => const Left(Failure.unknown()));
    final bloc = build();

    // Act
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Assert
    expect(bloc.state.phase, const ScanPhase.noText(photoPath: path));
  });

  test('when the AI fails the review still opens, empty', () async {
    // Arrange
    when(() => readText(path)).thenAnswer((_) async => const Right('TOTAL'));
    when(() => parse(any()))
        .thenAnswer((_) async => const Left(Failure.tooManyRequests()));
    final bloc = build();
    final seen = reviews(bloc);

    // Act
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Assert
    expect(seen, [
      const ReceiptReviewArgs(
        photoPath: path,
        ocrText: 'TOTAL',
        draft: ReceiptDraft.empty,
        aiFailure: ReceiptAiFailure.busy,
      ),
    ]);
  });

  test('without a connection the review says so', () async {
    // Arrange
    when(() => readText(path)).thenAnswer((_) async => const Right('TOTAL'));
    when(() => parse(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = build();
    final seen = reviews(bloc);

    // Act
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Assert
    expect(seen.single.aiFailure, ReceiptAiFailure.offline);
  });

  test('a picked photo is read the same way', () async {
    // Arrange
    when(() => readText(path)).thenAnswer((_) async => const Right('TOTAL'));
    when(() => parse(any())).thenAnswer((_) async => const Right(draft));
    final bloc = build();
    final seen = reviews(bloc);

    // Act
    await send(bloc, const ScanReceiptEvent.photoPicked(path));

    // Assert
    expect(seen, hasLength(1));
  });

  test('closing the gallery without a photo does nothing', () async {
    // Arrange
    final bloc = build();

    // Act
    await send(bloc, const ScanReceiptEvent.photoPicked(null));

    // Assert
    expect(bloc.state.phase, const ScanPhase.camera());
    verifyNever(() => readText(any()));
  });

  test('retaking during processing drops its result', () async {
    // Arrange
    final text = Completer<Either<Failure, String?>>();
    when(() => readText(path)).thenAnswer((_) => text.future);
    final bloc = build();
    final seen = reviews(bloc);
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Act
    await send(bloc, const ScanReceiptEvent.retakeRequested());
    text.complete(const Right('TOTAL'));
    await Future<void>.delayed(Duration.zero);

    // Assert
    expect(bloc.state.phase, const ScanPhase.camera());
    expect(seen, isEmpty);
    verifyNever(() => parse(any()));
  });

  test('retaking from the no-text sheet returns to the camera', () async {
    // Arrange
    when(() => readText(path)).thenAnswer((_) async => const Right(null));
    final bloc = build();
    await send(bloc, const ScanReceiptEvent.photoTaken(path));

    // Act
    await send(bloc, const ScanReceiptEvent.retakeRequested());

    // Assert
    expect(bloc.state.phase, const ScanPhase.camera());
  });

  test('the shutter is ignored while a photo is being taken', () async {
    // Arrange
    final bloc = build();
    await send(
      bloc,
      const ScanReceiptEvent.cameraStatusChanged(CameraStatus.ready),
    );
    final before = bloc.state.canCapture;

    // Act
    await send(bloc, const ScanReceiptEvent.captureStarted());
    final first = bloc.state.isCapturing;
    await send(bloc, const ScanReceiptEvent.captureStarted());

    // Assert
    expect(before, isTrue);
    expect(first, isTrue);
    expect(bloc.state.canCapture, isFalse);
  });

  test('a failed capture is reported once and frees the shutter', () async {
    // Arrange
    final bloc = build();
    final failures = <bool>[];
    final sub = bloc.stream.listen((s) => failures.add(s.captureFailed));
    addTearDown(sub.cancel);
    await send(
      bloc,
      const ScanReceiptEvent.cameraStatusChanged(CameraStatus.ready),
    );
    await send(bloc, const ScanReceiptEvent.captureStarted());

    // Act
    await send(bloc, const ScanReceiptEvent.captureFailed());

    // Assert
    expect(failures, contains(true));
    expect(bloc.state.captureFailed, isFalse);
    expect(bloc.state.isCapturing, isFalse);
  });
}
