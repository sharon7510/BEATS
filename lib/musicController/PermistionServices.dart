import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    print('Storage Permission Status: $status'); // Log permission status

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if the permission is permanently denied
      openAppSettings();
      return false;
    }
    return false;
  }
}