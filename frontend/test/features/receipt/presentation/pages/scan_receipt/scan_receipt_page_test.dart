import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/read_receipt_text_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/bloc/scan_receipt_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/camera/receipt_camera.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/scan_receipt_page.dart';

class _MockReadText extends Mock implements ReadReceiptTextUseCase {}

class _MockParse extends Mock implements ParseReceiptUseCase {}

/// A camera that opens as [status] and "takes" [photo].
class _FakeCamera implements ReceiptCamera {
  _FakeCamera({this.status = CameraStatus.ready});

  final CameraStatus status;
  static const photo = '/tmp/photo.jpg';
  int opened = 0;
  int pictures = 0;
  bool? flash;

  @override
  Future<CameraStatus> open() async {
    opened++;
    return status;
  }

  @override
  Future<void> close() async {}

  @override
  Future<String> takePicture() async {
    pictures++;
    return photo;
  }

  @override
  Future<void> setFlash({required bool on}) async => flash = on;

  @override
  Widget preview() => const ColoredBox(color: Colors.black);
}

void main() {
  late _MockReadText readText;
  late _MockParse parse;

  setUp(() {
    readText = _MockReadText();
    parse = _MockParse();
  });

  /// Opens the scanner from a launcher, with routes for where it can go.
  Future<void> openScanner(
    WidgetTester tester, {
    required _FakeCamera camera,
    PickReceiptPhoto? pickPhoto,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final bloc = ScanReceiptBloc(readText: readText, parse: parse);
    addTearDown(bloc.close);
    final router = GoRouter(
      initialLocation: '/launcher',
      routes: [
        GoRoute(
          path: '/launcher',
          builder: (context, _) => TextButton(
            onPressed: () => context.push(AppRoutes.receiptScan),
            child: const Text('open'),
          ),
        ),
        GoRoute(
          path: AppRoutes.receiptScan,
          builder: (_, _) => BlocProvider.value(
            value: bloc,
            child: ScanReceiptUI(
              camera: camera,
              pickPhoto: pickPhoto ?? () async => null,
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.receiptReview,
          builder: (_, state) => Text(
            'review ${(state.extra! as ReceiptReviewArgs).draft.merchant}',
          ),
        ),
        GoRoute(
          path: AppRoutes.transactionNew,
          builder: (_, _) => const Text('add form'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('aims the camera at the receipt', (tester) async {
    // Arrange
    final camera = _FakeCamera();

    // Act
    await openScanner(tester, camera: camera);

    // Assert
    expect(camera.opened, 1);
    expect(find.text('Fit the whole receipt inside the frame'), findsOneWidget);
    expect(find.bySemanticsLabel('Take photo'), findsOneWidget);
    expect(find.byTooltip('Flash off'), findsOneWidget);
  });

  testWidgets('the flash button turns the flash on', (tester) async {
    // Arrange
    final camera = _FakeCamera();
    await openScanner(tester, camera: camera);

    // Act
    await tester.tap(find.byTooltip('Flash off'));
    await tester.pumpAndSettle();

    // Assert
    expect(camera.flash, isTrue);
    expect(find.byTooltip('Flash on'), findsOneWidget);
  });

  testWidgets('a photo with text opens the review', (tester) async {
    // Arrange
    when(() => readText(_FakeCamera.photo))
        .thenAnswer((_) async => const Right('TOTAL'));
    when(() => parse('TOTAL')).thenAnswer(
      (_) async => const Right(ReceiptDraft(merchant: 'Kopi Kenangan')),
    );
    final camera = _FakeCamera();
    await openScanner(tester, camera: camera);

    // Act
    await tester.tap(find.bySemanticsLabel('Take photo'));
    await tester.pumpAndSettle();

    // Assert
    expect(camera.pictures, 1);
    expect(find.text('review Kopi Kenangan'), findsOneWidget);
  });

  testWidgets('shows the steps while the photo is read', (tester) async {
    // Arrange
    final text = Completer<Either<Failure, String?>>();
    when(() => readText(any())).thenAnswer((_) => text.future);
    await openScanner(tester, camera: _FakeCamera());

    // Act
    await tester.tap(find.bySemanticsLabel('Take photo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Assert
    expect(find.text('Reading receipt…'), findsOneWidget);
    expect(find.text('Reading the text on your phone'), findsOneWidget);
    expect(find.text('Finding total, store and date'), findsOneWidget);

    // Cancel goes back to the camera.
    await tester.tap(find.text('Cancel'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Fit the whole receipt inside the frame'), findsOneWidget);
    text.complete(const Right(null));
    await tester.pumpAndSettle();
  });

  testWidgets('a photo without text offers a retake or typing it in', (
    tester,
  ) async {
    // Arrange
    when(() => readText(any())).thenAnswer((_) async => const Right(null));
    await openScanner(tester, camera: _FakeCamera());

    // Act
    await tester.tap(find.bySemanticsLabel('Take photo'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text("We couldn't read this receipt"), findsOneWidget);
    await tester.tap(find.text('Enter manually'));
    await tester.pumpAndSettle();
    expect(find.text('add form'), findsOneWidget);
  });

  testWidgets('without camera access the gallery still works', (tester) async {
    // Arrange
    when(() => readText('/tmp/picked.jpg'))
        .thenAnswer((_) async => const Right('TOTAL'));
    when(
      () => parse(any()),
    ).thenAnswer((_) async => const Right(ReceiptDraft(merchant: 'Indomaret')));
    final camera = _FakeCamera(status: CameraStatus.denied);
    await openScanner(
      tester,
      camera: camera,
      pickPhoto: () async => '/tmp/picked.jpg',
    );
    expect(find.text('Camera access is off'), findsOneWidget);

    // Act
    await tester.tap(find.bySemanticsLabel('Take photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Choose from gallery'));
    await tester.pumpAndSettle();

    // Assert
    expect(camera.pictures, 0);
    expect(find.text('review Indomaret'), findsOneWidget);
  });

  testWidgets('"Type instead" opens the add form', (tester) async {
    // Arrange
    await openScanner(tester, camera: _FakeCamera());

    // Act
    await tester.tap(find.text('Type instead'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('add form'), findsOneWidget);
  });
}
