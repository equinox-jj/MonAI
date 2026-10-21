import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';

/// An interface so screen tests run without the platform plugin.
abstract class ReceiptCamera {
  Future<CameraStatus> open();

  Future<void> close();

  Future<String> takePicture();

  Future<void> setFlash({required bool on});

  Widget preview();
}

typedef PickReceiptPhoto = Future<String?> Function();

Future<String?> pickReceiptFromGallery() async =>
    (await ImagePicker().pickImage(source: ImageSource.gallery))?.path;

class PluginReceiptCamera implements ReceiptCamera {
  CameraController? _controller;

  static const _deniedCodes = {
    'CameraAccessDenied',
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
  };

  @override
  Future<CameraStatus> open() async {
    if (_controller?.value.isInitialized ?? false) return CameraStatus.ready;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return CameraStatus.unavailable;
      final back = cameras
          .where((c) => c.lensDirection == CameraLensDirection.back)
          .firstOrNull;
      final controller = CameraController(
        back ?? cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _controller = controller;
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      return CameraStatus.ready;
    } on CameraException catch (e) {
      await close();
      return _deniedCodes.contains(e.code)
          ? CameraStatus.denied
          : CameraStatus.unavailable;
    }
  }

  @override
  Future<void> close() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  @override
  Future<String> takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('The camera is not open');
    }
    return (await controller.takePicture()).path;
  }

  @override
  Future<void> setFlash({required bool on}) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    await controller.setFlashMode(on ? FlashMode.torch : FlashMode.off);
  }

  @override
  Widget preview() {
    final controller = _controller;
    final size = controller?.value.previewSize;
    if (controller == null || size == null) return const SizedBox.expand();
    // The sensor's size is landscape; the screen is portrait.
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.height,
          height: size.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
