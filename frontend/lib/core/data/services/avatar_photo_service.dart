import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

enum AvatarPhotoSource { camera, gallery }

abstract class AvatarPhotoService {
  /// Null when the user cancelled. The system photo picker needs no storage
  /// permission.
  Future<String?> pick(AvatarPhotoSource source);

  Future<String?> cropSquare(
    String path, {
    required String title,
    required String done,
    required String cancel,
  });
}

class AvatarPhotoServiceImpl implements AvatarPhotoService {
  AvatarPhotoServiceImpl({ImagePicker? picker, ImageCropper? cropper})
    : _picker = picker ?? ImagePicker(),
      _cropper = cropper ?? ImageCropper();

  /// Larger than the uploaded 512 px, so compression has room to scale.
  static const _maxCropSide = 1024;

  // The cropper is dark, like the design's crop screen.
  static const _cropBackground = Color(0xFF0B0F1A);
  static const _cropAccent = Color(0xFFC8F169);

  final ImagePicker _picker;
  final ImageCropper _cropper;

  @override
  Future<String?> pick(AvatarPhotoSource source) async =>
      (await _picker.pickImage(
        source: switch (source) {
          AvatarPhotoSource.camera => ImageSource.camera,
          AvatarPhotoSource.gallery => ImageSource.gallery,
        },
        preferredCameraDevice: CameraDevice.front,
      ))?.path;

  @override
  Future<String?> cropSquare(
    String path, {
    required String title,
    required String done,
    required String cancel,
  }) async => (await _cropper.cropImage(
    sourcePath: path,
    maxWidth: _maxCropSide,
    maxHeight: _maxCropSide,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: title,
        toolbarColor: _cropBackground,
        toolbarWidgetColor: Colors.white,
        backgroundColor: _cropBackground,
        activeControlsWidgetColor: _cropAccent,
        statusBarLight: false,
        navBarLight: false,
        cropStyle: CropStyle.circle,
        lockAspectRatio: true,
        hideBottomControls: false,
      ),
      IOSUiSettings(
        title: title,
        doneButtonTitle: done,
        cancelButtonTitle: cancel,
        cropStyle: CropStyle.circle,
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
        aspectRatioPickerButtonHidden: true,
      ),
    ],
  ))?.path;
}
