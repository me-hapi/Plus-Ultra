import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppState { INITIAL, CONNECTING, CONNECTED, DISCONNECTED, AUTH_NOT_GRANTED }

class HealthLogic extends StateNotifier<AppState> {
  HealthLogic() : super(AppState.INITIAL);

  Future<void> initializeHealthConnect() async {
    Health().configure();
    await requestPermissions();
  }

  Future<void> installHealthConnect() async {
    await Health().installHealthConnect();
  }

  Future<void> getHealthConnectSdkStatus() async {
    final status = await Health().getHealthConnectSdkStatus();
    state = AppState.CONNECTING;
    if (status != null) {
      debugPrint('Health Connect Status: ${status.name.toUpperCase()}');
    }
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

      final isAvailable = await isHealthConnectAvailable();
      if (!isAvailable) {
        debugPrint('Health Connect is not available on this device.');
        return false;
      }

      final types = [
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ];

      final permissions = types.map((type) => HealthDataAccess.READ).toList();

      final granted =
          await Health().requestAuthorization(types, permissions: permissions);

      if (granted) {
        debugPrint('Permissions granted for Heart Rate and Blood Pressure.');
        state = AppState.CONNECTED;
        fetchHealthData();
        return true;
      } else {
        debugPrint('Permissions denied for Heart Rate and Blood Pressure.');
        state = AppState.AUTH_NOT_GRANTED;
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  Future<void> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 7));

      final types = [
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ];

      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: types,
      );

      if (healthData.isNotEmpty) {
        for (var data in healthData) {
          debugPrint('Data type: ${data.type}, Value: ${data.value}, Unit: ${data.unit}');
        }
      } else {
        debugPrint('No health data found for the selected period.');
      }
    } catch (e) {
      debugPrint('Error fetching health data: $e');
    }
  }
}

final healthLogicProvider = StateNotifierProvider<HealthLogic, AppState>((ref) => HealthLogic());
