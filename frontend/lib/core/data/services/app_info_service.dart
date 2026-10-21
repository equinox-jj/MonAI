import 'package:package_info_plus/package_info_plus.dart';

/// Facts about the installed build.
abstract class AppInfoService {
  /// The version name, e.g. `1.0.0`.
  Future<String> version();
}

/// [AppInfoService] read from the platform's package metadata.
class AppInfoServiceImpl implements AppInfoService {
  @override
  Future<String> version() async => (await PackageInfo.fromPlatform()).version;
}
