import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permission App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PermissionRequestPage(),
    );
  }
}

class PermissionRequestPage extends StatefulWidget {
  @override
  _PermissionRequestPageState createState() => _PermissionRequestPageState();
}

class _PermissionRequestPageState extends State<PermissionRequestPage> {
  String _permissionStatus = "Permission Not Requested";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _requestStoragePermission() async {
    // Android 11+ (API 30+)
    if (await Permission.manageExternalStorage.isGranted) {
      _permissionStatus = "Manage External Storage Permission Granted";
      // setState(() {
      //   _permissionStatus = "Manage External Storage Permission Granted";
      // });
    } else if (await Permission.manageExternalStorage.isDenied) {
      PermissionStatus status = await Permission.manageExternalStorage.request();
      _permissionStatus = status.isGranted ? "Granted" : "Denied";
      // setState(() {
      //   _permissionStatus = status.isGranted ? "Granted" : "Denied";
      // });
    } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings(); // Redirect to settings
    } else {
      PermissionStatus status = await Permission.storage.request();
      _permissionStatus = status.isGranted ? "Granted" : "Denied";
      // setState(() {
      //   _permissionStatus = status.isGranted ? "Granted" : "Denied";
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Storage Permission App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Permission Status:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _permissionStatus,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestStoragePermission,
              child: Text("Request Storage Permission"),
            ),
          ],
        ),
      ),
    );
  }
}
