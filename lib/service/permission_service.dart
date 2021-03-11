import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static void getPermission() async {
    await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((status) {
      if (status == PermissionStatus.denied) {
        requestPermission();
      }
    });
  }

  static void requestPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }
}
