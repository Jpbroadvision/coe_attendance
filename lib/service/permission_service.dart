import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static void getPermission() async {
    var status = await Permission.storage.status;

    if (status == PermissionStatus.denied) {
      requestPermission();
    }
  }

  static void requestPermission() async {
    await Permission.storage.request();
  }
}
