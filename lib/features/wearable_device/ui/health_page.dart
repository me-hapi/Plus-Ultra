import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
import 'package:lingap/features/wearable_device/data/supabase_db.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';
import 'package:lingap/features/wearable_device/ui/vital_card.dart';

enum AppState { INITIAL, CONNECTING, CONNECTED, DISCONNECTED, AUTH_NOT_GRANTED }

class HealthPage extends StatefulWidget {
  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  late HealthLogic healthLogic;
  AppState appState = AppState.INITIAL;
  final SupabaseDB supabase = SupabaseDB();
  bool isConnected = false;

  Map<String, dynamic> healthDataMap = {};

  @override
  void initState() {
    super.initState();
    healthLogic = HealthLogic();
    _initializeConnectionStatus();
    
  }

  Future<void> _initializeConnectionStatus() async {
    final result =
        await SharedPrefHelper.instance.getBool('isConnected') ?? false;
    setState(() {
      isConnected = result;
    });
    if (!result) {
      _initializeHealthConnect();
    } else {
      print('initialize');
      await _fetchHealthData();
    }
  }

  Future<void> _initializeHealthConnect() async {
    setState(() {
      appState = AppState.CONNECTING;
    });
    bool permissionsGranted = await healthLogic.requestPermissions();
    if (permissionsGranted) {
      setState(() {
        appState = AppState.CONNECTED;
      });
    } else {
      setState(() {
        appState = AppState.AUTH_NOT_GRANTED;
      });
    }
  }

  double _extractNumericValue(dynamic value) {
    if (value is num) {
      return value.toDouble(); // Directly return if it's already numeric
    }

    if (value is String) {
      if (value.contains('/')) {
        // Handle blood pressure (systolic/diastolic format)
        List<String> parts = value.split('/');
        double systolic = double.tryParse(parts[0]) ?? 0.0;
        double diastolic = double.tryParse(parts[1]) ?? 0.0;
        return systolic - diastolic; // Return Pulse Pressure
      } else {
        // Handle single numeric string
        return double.tryParse(value) ?? 0.0;
      }
    }

    return 0.0; // Default fallback
  }

  Future<void> _fetchHealthData() async {
    final List<Map<String, dynamic>> data = await supabase.fetchVitalData();

    if (data.isEmpty) {
      print('No health data found.');
      return;
    }

    Map<String, List<Map<String, dynamic>>> categorizedData = {};

    for (var entry in data) {
      String type = entry['type'];
      DateTime date = DateTime.parse(entry['date']);
      String rawValue =
          entry['value'].toString(); // Keep the raw value for latest
      double numericValue =
          _extractNumericValue(entry['value']); // Convert only for spots

      if (!categorizedData.containsKey(type)) {
        categorizedData[type] = [];
      }

      categorizedData[type]!.add({
        'date': date,
        'value': numericValue, // Use numeric value for spots
        'rawValue': rawValue, // Store raw value separately
      });
    }

    Map<String, dynamic> result = {};

    categorizedData.forEach((key, value) {
      // Sort by time (earliest to latest)
      value.sort((a, b) => a['date'].compareTo(b['date']));

      // Convert to FlSpot
      List<FlSpot> flSpots = value.map((data) {
        double x = data['date'].millisecondsSinceEpoch.toDouble();
        double y = data['value']; // Use extracted numeric value
        return FlSpot(x, y);
      }).toList();

      // Latest metric (most recent value as raw string)
      String latestMetric = value.isNotEmpty ? value.last['rawValue'] : 'N/A';

      result[key] = {
        'spots': flSpots,
        'latest': latestMetric, // Use raw string for latest
      };
    });

    print('Transformed Data: $result');
    setState(() {
      healthDataMap = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/utils/brownBack.png',
                  width: 25,
                  height: 25,
                ),
              ), SizedBox(
                width: 10,
              ),
              Text(
                'Linked',
                style: TextStyle(
                  color: mindfulBrown['Brown80'],
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/vitals/smartwatch.png',
            width: 400,
            height: 400,
          ),
          SizedBox(height: 20),
          ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              children: [
                VitalCard(
                  title: "Heart Rate",
                  imageUrl: "assets/vitals/heart.png",
                  metric: healthDataMap['HEART_RATE']?['latest'] ?? 'N/A',
                  lineGraphData: healthDataMap['HEART_RATE']?['spots'] ?? [],
                  graphColor: presentRed['Red50']!,
                ),
                VitalCard(
                  title: "Blood Oxygen",
                  imageUrl: "assets/utils/oxygen2.png",
                  metric: healthDataMap['BLOOD_OXYGEN']?['latest'] ?? 'N/A',
                  lineGraphData:
                      healthDataMap['BLOOD_OXYGEN']?['spots'] ?? [],
                  graphColor: empathyOrange['Orange50']!,
                ),
              ]),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: isConnected
                ? serenityGreen['Green50']
                : optimisticGray['Gray50'],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isConnected ? 'Permission Granted' : 'Idle',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
