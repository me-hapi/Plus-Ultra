import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
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
    isConnected = result;
    if (!result) {
      _initializeHealthConnect();
    } else {
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

  Future<void> _fetchHealthData() async {
    Map<String, dynamic> data = await healthLogic.fetchHealthData();
    setState(() {
      healthDataMap = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    String bloodPressureMetric =
        (healthDataMap['HealthDataType.BLOOD_PRESSURE_SYSTOLIC']?['latest'] ??
                'N/A') +
            '/' +
            (healthDataMap['HealthDataType.BLOOD_PRESSURE_DIASTOLIC']
                    ?['latest'] ??
                'N/A');

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
              Text(
                'Linked',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: mindfulBrown['80']),
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
                  metric: healthDataMap['HealthDataType.HEART_RATE']
                          ?['latest'] ??
                      'N/A',
                  lineGraphData: healthDataMap['HealthDataType.HEART_RATE']
                          ?['spots'] ??
                      [],
                  graphColor: presentRed['Red50']!,
                ),
                VitalCard(
                  title: "Blood Pressure",
                  imageUrl: "assets/vitals/blood.png",
                  metric: bloodPressureMetric,
                  lineGraphData:
                      healthDataMap['HealthDataType.BLOOD_PRESSURE_SYSTOLIC']
                              ?['spots'] ??
                          [],
                  graphColor: empathyOrange['Orange50']!,
                ),
              ]),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: appState == AppState.CONNECTED
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
