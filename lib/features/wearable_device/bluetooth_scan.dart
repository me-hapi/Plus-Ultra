import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScanPage extends StatefulWidget {
  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final List<DiscoveredDevice> scannedDevices = [];
  final List<String> logMessages = [];
  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndScan();
  }

  void checkPermissionsAndScan() async {
    if (await Permission.bluetooth.isGranted && await Permission.location.isGranted) {
      turnOnBluetoothAndScan();
    } else {
      await Permission.bluetooth.request();
      await Permission.location.request();
      if (await Permission.bluetooth.isGranted && await Permission.location.isGranted) {
        turnOnBluetoothAndScan();
      } else {
        addLog("Permissions not granted");
      }
    }
  }

  void turnOnBluetoothAndScan() async {
    // Start scanning for devices
    _scanSubscription = _ble.scanForDevices(withServices: []).listen((device) {
      setState(() {
        if (scannedDevices.indexWhere((d) => d.id == device.id) == -1) {
          scannedDevices.add(device);
          addLog("Device found: ${device.name.isNotEmpty ? device.name : 'Unnamed Device'} - ${device.id}");
        }
      });
    }, onError: (error) {
      addLog("Scan failed: $error");
    });
  }

  void discoverServices(DiscoveredDevice device) async {
    try {
      // Establish connection to the device
      _connectionSubscription = _ble.connectToDevice(id: device.id).listen((connectionState) {
        addLog('Connection state: $connectionState');
        switch (connectionState.connectionState) {
          case DeviceConnectionState.connecting:
            addLog("Device is connecting...");
            break;
          case DeviceConnectionState.connected:
            addLog("Device connected.");
            break;
          case DeviceConnectionState.disconnected:
            addLog("Device disconnected.");
            break;
          case DeviceConnectionState.disconnecting:
            addLog("Device is disconnecting...");
            break;
        }
      }, onError: (error) {
        addLog('Connection failed: $error');
      });

      // Wait until the device is connected
      await _connectionSubscription?.asFuture();

      // Discover services
      await _ble.discoverAllServices(device.id);
      addLog('Done discovering services');
      final List<Service> services = await _ble.getDiscoveredServices(device.id);
      if (services.isEmpty) {
        addLog('No services found on device: ${device.id}');
      } else {
        for (Service service in services) {
          addLog('Service UUID: ${service.deviceId}');
          for (var characteristic in service.characteristics) {
            addLog('Characteristic UUID: ${characteristic.id}');
          }
        }
      }
    } catch (e) {
      addLog('Error while discovering services: $e');
    } finally {
      // Disconnect from the device
      addLog('Disconnecting device');
      _connectionSubscription?.cancel();
    }
  }

  void addLog(String message) {
    setState(() {
      logMessages.add(message);
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scan'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: scannedDevices.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(scannedDevices[index].name.isNotEmpty
                            ? scannedDevices[index].name
                            : 'Unknown Device'),
                        subtitle: Text(scannedDevices[index].id),
                        onTap: () => discoverServices(scannedDevices[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: logMessages.length,
                itemBuilder: (context, index) {
                  return Text(logMessages[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
