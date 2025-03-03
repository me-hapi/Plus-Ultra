// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ForegroundHealthService {
//   static void startForegroundService() async {
//     // Initialize Supabase
//     await Supabase.initialize(
//       url: 'https://roklxdmfmwyniafvremi.supabase.co',
//       anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJva2x4ZG1mbXd5bmlhZnZyZW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5Nzk5MDQsImV4cCI6MjA0NzU1NTkwNH0.zWPFIV5mr6jNwgdU1JHAHQZANHA69qrpTanOcokD5YQ',
//     );

//     // Initialize the foreground task
//     FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'health_foreground_service',
//         channelName: 'Health Data Fetch Service',
//         channelDescription: 'Runs a background task to fetch health data.',
//       ),
//       iosNotificationOptions: IOSNotificationOptions(
//         showNotification: true,
//         playSound: false,
//       ),
//       foregroundTaskOptions: ForegroundTaskOptions(
//         interval:900000 ,
//         autoRunOnBoot: true,
//         allowWakeLock: true,
//         allowWifiLock: true,
//         isOnceEvent: false,
//       ),
//     );

//     await FlutterForegroundTask.startService(
//       notificationTitle: 'Fetching Health Data',
//       notificationText: 'Running background health monitoring...',
//       callback: startCallback,
//     );
//   }
// }

// @pragma('vm:entry-point')
// void startCallback() {
//   FlutterForegroundTask.setTaskHandler(HealthTaskHandler());
// }

// class HealthTaskHandler extends TaskHandler {
//   @override
//   Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
//     debugPrint('Foreground service started at: $timestamp');
//   }

//   @override
//   void onRepeatEvent(DateTime timestamp) async {
//     try {
//       debugPrint('🔄 Fetching health data at: $timestamp');
//       await HealthLogic().fetchHealthData();
//       debugPrint('✅ Health data fetched successfully.');
//     } catch (e) {
//       debugPrint('❌ Error fetching health data: $e');
//     }
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp) async {
//     debugPrint('Foreground service stopped at: $timestamp');
//   }
// }
