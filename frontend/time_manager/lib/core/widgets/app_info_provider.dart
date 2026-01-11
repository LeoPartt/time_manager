import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider extends ChangeNotifier {
  String version = '';
  String buildNumber = '';
  bool isLoaded = false;

  Future<void> load() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
    isLoaded = true;
    notifyListeners();
  }
}
