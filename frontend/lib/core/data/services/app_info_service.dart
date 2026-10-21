import 'package:package_info_plus/package_info_plus.dart';

abstract class AppInfoService {
  Future<String> version();
}

class AppInfoServiceImpl implements AppInfoService {
  @override
  Future<String> version() async => (await PackageInfo.fromPlatform()).version;
}
