import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthConnectService {
  final Health _health = Health();

  // Request permissions to access Health data (Heart Rate and Blood Pressure)
  Future<bool> requestPermissions() async {
    try {
      _health.configure();
      
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
          await _health.requestAuthorization(types, permissions: permissions);
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

  Future<bool> isHealthConnectAvailable() async {
    try {
      return await _health.isHealthConnectAvailable();
    } catch (e) {
      debugPrint('Health Connect is not available: $e');
      return false;
    }
  }

  // Example function to fetch heart rate data
  Future<List<HealthDataPoint>> fetchHeartRateData(
      DateTime startDate, DateTime endDate) async {
    try {
      final data = await _health.getHealthDataFromTypes(
          types: [HealthDataType.HEART_RATE],
          startTime: startDate,
          endTime: endDate);
      debugPrint('Heart Rate Data: ${data.length} records fetched.');
      return data;
    } catch (e) {
      debugPrint('Error fetching heart rate data: $e');
      return [];
    }
  }

  // Example function to fetch blood pressure data
  Future<List<HealthDataPoint>> fetchBloodPressureData(
      DateTime startDate, DateTime endDate) async {
    try {
      final data = await _health.getHealthDataFromTypes(
        types: [
          HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        ],
        startTime: startDate,
        endTime: endDate,
      );
      debugPrint('Blood Pressure Data: ${data.length} records fetched.');
      return data;
    } catch (e) {
      debugPrint('Error fetching blood pressure data: $e');
      return [];
    }
  }
}
