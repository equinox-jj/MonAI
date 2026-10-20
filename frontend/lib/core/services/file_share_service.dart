import 'dart:ui';

import 'package:share_plus/share_plus.dart';

/// Hands a file to another app through the system share sheet.
abstract class FileShareService {
  /// Shares the file at [path] as [mimeType]. [title] heads the share
  /// sheet. [origin] is where the sheet points from on tablets.
  Future<void> shareFile(
    String path, {
    required String mimeType,
    required String title,
    Rect? origin,
  });
}

/// [FileShareService] backed by `share_plus`.
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
