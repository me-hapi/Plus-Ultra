import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthConnectApp extends StatefulWidget {
  @override
  _HealthConnectAppState createState() => _HealthConnectAppState();
}

class _HealthConnectAppState extends State<HealthConnectApp> {
  AppState _state = AppState.INITIAL;
  Text? _contentHealthConnectStatus;

  @override
  void initState() {
    super.initState();
    _initializeHealthConnect();
  }

  Future<void> _initializeHealthConnect() async {
    // Configure the health plugin before use
    Health().configure();
    await requestPermissions();
  }

  Future<void> installHealthConnect() async {
    await Health().installHealthConnect();
  }

  Future<void> getHealthConnectSdkStatus() async {
    final status = await Health().getHealthConnectSdkStatus();
    setState(() {
      _contentHealthConnectStatus =
          Text('Health Connect Status: ${status?.name.toUpperCase()}');
      _state = AppState.HEALTH_CONNECT_STATUS;
    });
  }

  Future<bool> isHealthConnectAvailable() async {
    try {
      return await Health().isHealthConnectAvailable();
    } catch (e) {
      debugPrint('Health Connect is not available: $e');
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      Health().configure();

      // Check if Health Connect is available
      final isAvailable = await isHealthConnectAvailable();
      if (!isAvailable) {
        debugPrint('Health Connect is not available on this device.');
        return false;
      } else {
        debugPrint('Health Connect is available on this device.');
      }

      // Define the types of health data to request permissions for
      final types = [
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ];

      final permissions = types.map((type) => HealthDataAccess.READ).toList();

      // Request permissions
      final granted =
          await Health().requestAuthorization(types, permissions: permissions);
      if (granted) {
        debugPrint('Permissions granted for Heart Rate and Blood Pressure.');
        return true;
      } else {
        debugPrint('Permissions denied for Heart Rate and Blood Pressure.');
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  Future<void> authorize() async {

    // Define the types of health data to access
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    ];

    // Create a permissions list with the same length as `types`
    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    // Check if the app already has the necessary permissions
    final hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    bool authorized = false;

    // Request authorization if permissions are not already granted
    if (!hasPermissions!) {
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }

    // Update the app state based on the authorization result
    setState(() => _state =
        (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health Connect App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: installHealthConnect,
                child: Text('Install Health Connect'),
              ),
              ElevatedButton(
                onPressed: getHealthConnectSdkStatus,
                child: Text('Check Health Connect Status'),
              ),
              ElevatedButton(
                onPressed: authorize,
                child: Text('Authorize Health Data Access'),
              ),
              if (_contentHealthConnectStatus != null)
                _contentHealthConnectStatus!,
            ],
          ),
        ),
      ),
    );
  }
}

enum AppState { INITIAL, HEALTH_CONNECT_STATUS, AUTHORIZED, AUTH_NOT_GRANTED }
