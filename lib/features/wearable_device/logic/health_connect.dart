import 'package:fl_chart/fl_chart.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';

class HealthLogic {
  final Health health;

  HealthLogic() : health = Health();

  Future<bool> requestPermissions() async {
    try {
      health.configure();

      bool isAvailable = await isHealthConnectAvailable();
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

      bool granted =
          await health.requestAuthorization(types, permissions: permissions);

      if (granted) {
        debugPrint('Permissions granted for Heart Rate and Blood Pressure.');
        fetchHealthData();
        await SharedPrefHelper.instance.setBool('isConnected', true);
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
      return await health.isHealthConnectAvailable();
    } catch (e) {
      debugPrint('Health Connect is not available: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final types = [
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ];

      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: weekAgo,
        endTime: now,
        types: types,
      );

      if (healthData.isNotEmpty) {
        for (var data in healthData) {
          debugPrint(
              'Data type: ${data.type}, Value: ${data.value}, Unit: ${data.unit}');
        }

        Map<String, List<HealthDataPoint>> categorizedData = {};
        for (var data in healthData) {
          if (!categorizedData.containsKey(data.type.toString())) {
            categorizedData[data.type.toString()] = [];
          }
          categorizedData[data.type.toString()]!.add(data);
        }

        Map<String, dynamic> result = {};
        categorizedData.forEach((key, value) {
          // Sort by time
          value.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

          // Convert to FlSpot
          List<FlSpot> flSpots = value.map((data) {
            double x = data.dateFrom.millisecondsSinceEpoch.toDouble();
            // Extract numeric value properly
            double y = _extractNumericValue(data.value);
            return FlSpot(x, y);
          }).toList();

          String latestMetric = value.isNotEmpty
              ? _extractNumericValue(value.last.value).toInt().toString()
              : 'N/A';

          result[key] = {
            'spots': flSpots,
            'latest': latestMetric,
          };
        });

        return result;
      } else {
        debugPrint('No health data found.');
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching health data: $e');
      return {};
    }
  }

// Helper function to extract numeric value from HealthDataPoint.value
  double _extractNumericValue(dynamic value) {
    if (value is NumericHealthValue) {
      return value.numericValue.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0; // Default to 0.0 if extraction fails
    }
  }
}
