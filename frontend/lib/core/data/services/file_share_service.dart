import 'dart:ui';

import 'package:share_plus/share_plus.dart';

abstract class FileShareService {
  Future<void> shareFile(
    String path, {
    required String mimeType,
    required String title,
    Rect? origin,
  });
}

class FileShareServiceImpl implements FileShareService {
  @override
  Future<void> shareFile(
    String path, {
    required String mimeType,
    required String title,
    Rect? origin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path, mimeType: mimeType)],
        title: title,
        subject: title,
        sharePositionOrigin: origin,
      ),
    );
  }
}
