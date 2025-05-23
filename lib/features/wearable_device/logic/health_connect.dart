import 'package:fl_chart/fl_chart.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
import 'package:lingap/features/wearable_device/data/supabase_db.dart';

class HealthLogic {
  final Health health;
  final SupabaseDB supabase = SupabaseDB();

  HealthLogic() : health = Health();

  Future<bool> requestPermissions() async {
    try {
      health.configure();

      bool isAvailable = await isHealthConnectAvailable();
      if (!isAvailable) {
        debugPrint('Health Connect is not available on this device.');
        return false;
      }

      final types = [HealthDataType.HEART_RATE, HealthDataType.BLOOD_OXYGEN];

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

  Future<void> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 1));
      final types = [HealthDataType.HEART_RATE, HealthDataType.BLOOD_OXYGEN];

      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: weekAgo,
        endTime: now,
        types: types,
      );
      print("HEALTHDATA: $healthData");

      if (healthData.isNotEmpty) {
        Map<String, List<HealthDataPoint>> categorizedData = {};
        List<Map<String, dynamic>> mergedHistory = []; // Merged history list

        for (var data in healthData) {
          String type = data.typeString;
          String uid = data.uuid;
          double value = _extractNumericValue(data.value);
          String date = data.dateFrom.toIso8601String();

          if (!categorizedData.containsKey(type)) {
            categorizedData[type] = [];
          }
          categorizedData[type]!.add(data);

          // Add Heart Rate and Blood Oxygen directly to merged history
          mergedHistory.add({
            "type": type,
            "date": date,
            "value": value,
            "uid": uid,
          });
        }

        Map<String, dynamic> result = {};
        categorizedData.forEach((key, value) {
          // Sort by time
          value.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

          // Convert to FlSpot
          List<FlSpot> flSpots = value.map((data) {
            double x = data.dateFrom.millisecondsSinceEpoch.toDouble();
            double y = _extractNumericValue(data.value);
            return FlSpot(x, y);
          }).toList();

          // Latest metric
          String latestMetric = value.isNotEmpty
              ? _extractNumericValue(value.last.value).toInt().toString()
              : 'N/A';

          result[key] = {
            'spots': flSpots,
            'latest': latestMetric,
          };
        });

        // Add merged history to the result
        result['history'] = mergedHistory;
        print('MERGED HISTORY: $mergedHistory');
        await supabase.insertHealthHistory(mergedHistory);
      } else {
        debugPrint('No health data found.');
      }
    } catch (e) {
      debugPrint('Error fetching health data: $e');
    }
  }
}
