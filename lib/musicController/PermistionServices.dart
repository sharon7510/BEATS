import 'package:permission_handler/permission_handler.dart';

// class PermissionService {
//   String _permissionStatus = "Permission Not Requested";
//   // Request storage permission based on Android version
//   Future<void> requestStoragePermission() async {
//     // Android 11+ (API 30+)
//     if (await Permission.manageExternalStorage.isGranted) {
//       _permissionStatus = "Manage External Storage Permission Granted";
//       // setState(() {
//       //   _permissionStatus = "Manage External Storage Permission Granted";
//       // });
//     } else if (await Permission.manageExternalStorage.isDenied) {
//       PermissionStatus status = await Permission.manageExternalStorage.request();
//       _permissionStatus = status.isGranted ? "Granted" : "Denied";
//       // setState(() {
//       //   _permissionStatus = status.isGranted ? "Granted" : "Denied";
//       // });
//     } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
//       openAppSettings(); // Redirect to settings
//     } else {
//       PermissionStatus status = await Permission.storage.request();
//       _permissionStatus = status.isGranted ? "Granted" : "Denied";
//       // setState(() {
//       //   _permissionStatus = status.isGranted ? "Granted" : "Denied";
//       // });
//     }
//   }
//
// // Future<bool> requestStoragePermission() async {
//   //   // For Android 11+, check MANAGE_EXTERNAL_STORAGE permission first
//   //   if (await Permission.manageExternalStorage.isGranted) {
//   //     return true;
//   //   }
//   //
//   //   // For Android 10 and below, check for regular storage permission
//   //   if (await Permission.storage.isGranted) {
//   //     return true;
//   //   }
//   //
//   //   // Request permission based on API level
//   //   PermissionStatus status;
//   //   if (await Permission.manageExternalStorage.isDenied) {
//   //     status = await Permission.manageExternalStorage.request();
//   //   } else {
//   //     status = await Permission.storage.request();
//   //   }
//   //
//   //   // Check the status of the permission request
//   //   if (status.isGranted) {
//   //     return true;
//   //   } else if (status.isPermanentlyDenied) {
//   //     print('Storage permission permanently denied. Opening app settings...');
//   //     openAppSettings();  // Open settings for the user to manually enable permission
//   //     return false;
//   //   } else if (status.isDenied) {
//   //     print('Storage permission denied.');
//   //     return false;
//   //   }
//   //
//   //   return false;
//   // }
// }




// class PermissionService {
//   Future<bool> requestStoragePermission() async {
//     if (await Permission.storage.isGranted) {
//       return true; // If permission is already granted, no need to request again
//     }
//
//     // For Android 11 and above (API 30+), check for MANAGE_EXTERNAL_STORAGE
//     if (await Permission.manageExternalStorage.isGranted) {
//       return true;
//     }
//
//     // Request storage permission for Android 10 and below (or standard storage)
//     PermissionStatus status = await Permission.storage.request();
//
//     print('Storage Permission Status: $status'); // Log permission status
//
//     if (status.isGranted) {
//       return true;
//     } else if (status.isPermanentlyDenied) {
//       // Open app settings if the permission is permanently denied
//       print('Permission permanently denied, opening app settings...');
//       openAppSettings();
//       return false;
//     } else if (status.isDenied) {
//       print('Storage Permission Denied.');
//       return false;
//     }
//
//     // Handle additional cases (e.g., restricted)
//     return false;
//   }
//
//   // Request full storage access (for Android 11+)
//   Future<bool> requestManageStoragePermission() async {
//     if (await Permission.manageExternalStorage.isGranted) {
//       return true;
//     }
//
//     PermissionStatus status = await Permission.manageExternalStorage.request();
//
//     print('Manage External Storage Permission Status: $status'); // Log permission status
//
//     if (status.isGranted) {
//       return true;
//     } else if (status.isPermanentlyDenied) {
//       print('Manage External Storage Permission permanently denied, opening app settings...');
//       openAppSettings();
//       return false;
//     }
//
//     return false;
//   }
// }

