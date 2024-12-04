import 'package:flutter/material.dart';
import 'package:lingap/features/wearable_device/bluetooth_scan.dart';

class WearableTechPage extends StatefulWidget {
  const WearableTechPage({Key? key}) : super(key: key);

  @override
  _WearableTechPageState createState() => _WearableTechPageState();
}

class _WearableTechPageState extends State<WearableTechPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wearable Tech Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BluetoothScanPage()),
            );
          },
          child: Text('Go to Bluetooth Scan Page'),
        ),
      ),
    );
  }
}