import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/bloc/scan_receipt_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/camera/receipt_camera.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_receipt_state_extension.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_camera_view.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_no_text.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_processing.dart';
import 'package:monai/route_path.dart';

class ScanReceiptPage extends StatelessWidget {
  const ScanReceiptPage({super.key, this.camera, this.pickPhoto});
  final ReceiptCamera? camera;
  final PickReceiptPhoto? pickPhoto;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScanReceiptBloc>(),
      child: ScanReceiptUI(
        camera: camera,
        pickPhoto: pickPhoto ?? pickReceiptFromGallery,
      ),
    );
  }
}

class ScanReceiptUI extends StatefulWidget {
  const ScanReceiptUI({required this.pickPhoto, super.key, this.camera});

  final ReceiptCamera? camera;
  final PickReceiptPhoto pickPhoto;

  @override
  State<ScanReceiptUI> createState() => _ScanReceiptUIState();
}

class _ScanReceiptUIState extends State<ScanReceiptUI>
    with WidgetsBindingObserver {
  late final ReceiptCamera _camera = widget.camera ?? PluginReceiptCamera();

  /// The camera was freed because the app left the foreground or the
  /// review opened; it opens again on return.
  bool _cameraParked = false;

  /// The review is open, so app pauses don't touch the camera.
  bool _reviewOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_reviewOpen) return;
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        // Only an open camera: "inactive" also fires while the system asks
        // for the permission, and the camera is still opening then.
        if (_bloc.state.camera == CameraStatus.ready) _parkCamera();
      case AppLifecycleState.resumed:
        if (_cameraParked) _openCamera();
      case AppLifecycleState.inactive || AppLifecycleState.detached:
        break;
    }
  }

  ScanReceiptBloc get _bloc => context.read<ScanReceiptBloc>();

  Future<void> _openCamera() async {
    _cameraParked = false;
    final status = await _camera.open();
    if (!mounted) return;
    _bloc.add(ScanReceiptEvent.cameraStatusChanged(status));
    if (status == CameraStatus.ready && _bloc.state.flashOn) {
      await _camera.setFlash(on: true);
    }
  }

  Future<void> _parkCamera() async {
    _cameraParked = true;
    _bloc.add(const ScanReceiptEvent.cameraStatusChanged(CameraStatus.opening));
    await _camera.close();
  }

  Future<void> _capture() async {
    if (!_bloc.state.canCapture) return;
    _bloc.add(const ScanReceiptEvent.captureStarted());
    try {
      final path = await _camera.takePicture();
      if (mounted) _bloc.add(ScanReceiptEvent.photoTaken(path));
    } on Object {
      if (mounted) _bloc.add(const ScanReceiptEvent.captureFailed());
    }
  }

  Future<void> _pickPhoto() async {
    final path = await widget.pickPhoto();
    if (mounted) _bloc.add(ScanReceiptEvent.photoPicked(path));
  }

  void _toggleFlash() => _bloc.add(const ScanReceiptEvent.flashToggled());

  void _retake() => _bloc.add(const ScanReceiptEvent.retakeRequested());

  void _typeInstead() => context.pushReplacement(RoutePath.transactionNew);

  void _close() => context.pop();

  Future<void> _openReview(BuildContext context, ScanReceiptState state) async {
    final review = state.review;
    if (review == null) return;
    _reviewOpen = true;
    await _parkCamera();
    if (!context.mounted) return;
    await context.push<void>(RoutePath.receiptReview, extra: review);
    _reviewOpen = false;
    // A save leaves the scanner too; only Back or Retake land here.
    if (mounted) await _openCamera();
  }

  void _setFlash(BuildContext context, ScanReceiptState state) =>
      _camera.setFlash(on: state.flashOn);

  void _showCaptureFailed(BuildContext context, ScanReceiptState state) =>
      showMonAISnackBar(
        context,
        message: context.l10n.receiptScanCaptureFailed,
      );

  @override
  Widget build(BuildContext context) {
    // The "couldn't read" sheet keeps the app's own theme.
    final appTheme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<ScanReceiptBloc, ScanReceiptState>(
          listenWhen: (previous, current) =>
              current.review != null && previous.review != current.review,
          listener: _openReview,
        ),
        BlocListener<ScanReceiptBloc, ScanReceiptState>(
          listenWhen: (previous, current) =>
              previous.flashOn != current.flashOn,
          listener: _setFlash,
        ),
        BlocListener<ScanReceiptBloc, ScanReceiptState>(
          listenWhen: (previous, current) =>
              current.captureFailed && !previous.captureFailed,
          listener: _showCaptureFailed,
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Theme(
          data: MonAITheme.dark(),
          child: Scaffold(
            backgroundColor: MonAIPalette.gray925,
            body: BlocSelector<ScanReceiptBloc, ScanReceiptState, ScanPhase>(
              selector: (state) => state.phase,
              builder: (context, phase) => switch (phase) {
                CameraScanPhase() => ScanReceiptCameraView(
                  preview: _camera.preview,
                  onClose: _close,
                  onToggleFlash: _toggleFlash,
                  onCapture: _capture,
                  onPickPhoto: _pickPhoto,
                  onTypeInstead: _typeInstead,
                ),
                ProcessingScanPhase(:final photoPath, :final step) =>
                  ScanReceiptProcessing(
                    photoPath: photoPath,
                    step: step,
                    onCancel: _retake,
                  ),
                NoTextScanPhase(:final photoPath) => ScanReceiptNoText(
                  photoPath: photoPath,
                  sheetTheme: appTheme,
                  onClose: _close,
                  onRetake: _retake,
                  onEnterManually: _typeInstead,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
