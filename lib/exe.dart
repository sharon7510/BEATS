import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart'; // For accessing the device storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter engine is ready for async operations

  // Get the directory where Hive can store the boxes
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); // Initialize Hive and provide the directory path

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box? _box;

  @override
  void initState() {
    super.initState();
    _openHiveBox();
  }

  Future<void> _openHiveBox() async {
    // Open a Hive box called 'myBox' where we will store key-value pairs
    _box = await Hive.openBox('myBox');
  }

  // Function to add sample data to the Hive box
  Future<void> _addSampleData() async {
    await _box?.put('name', 'John Doe');
    await _box?.put('age', 28);
    await _box?.put('city', 'New York');

    print('Sample data added to Hive!');
  }

  // Function to print all data stored in the Hive box
  Future<void> _printHiveData() async {
    if (_box != null && _box!.isNotEmpty) {
      print('Hive Box Data:');
      _box!.toMap().forEach((key, value) {
        print('Key: $key, Value: $value');
      });
    } else {
      print('The box is empty.');
    }
  }

  // Function to clear all data in the box
  Future<void> _clearHiveData() async {
    await _box?.clear();
    print('All data cleared from Hive!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addSampleData,
              child: Text('Add Sample Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _printHiveData,
              child: Text('Print All Hive Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearHiveData,
              child: Text('Clear Hive Data'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close(); // Always close the Hive box when you're done
    super.dispose();
  }
}
