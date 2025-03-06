import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';
import 'package:lingap/modules/notification/data/supabase_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForegroundHealthService {
  static void startForegroundService() async {
    // Initialize the foreground task
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'health_foreground_service',
        channelName: 'Health Data Fetch Service',
        channelDescription: 'Runs a background task to fetch health data.',
      ),
      iosNotificationOptions: IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        interval: 300000,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
        isOnceEvent: false,
      ),
    );

    await FlutterForegroundTask.startService(
      notificationTitle: 'Fetching Health Data',
      notificationText: 'Running background health monitoring...',
      callback: startCallback,
    );
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(HealthTaskHandler());
}

class HealthTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    try {
      // Initialize Supabase in the background isolate.
      await Supabase.initialize(
        url: 'https://roklxdmfmwyniafvremi.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJva2x4ZG1mbXd5bmlhZnZyZW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5Nzk5MDQsImV4cCI6MjA0NzU1NTkwNH0.zWPFIV5mr6jNwgdU1JHAHQZANHA69qrpTanOcokD5YQ',
      );
    } catch (e) {
      // If Supabase is already initialized in this isolate, handle or ignore the error.
      debugPrint('Supabase already initialized in background isolate: $e');
    }
    debugPrint('Foreground service started at: $timestamp');
  }

  Future<void> _insertLogRecord(String content) async {
    try {
      final response = await Supabase.instance.client
          .from('log')
          .insert({'content': content});
      debugPrint('Log inserted: $content');
    } catch (e) {
      debugPrint('Exception inserting log: $e');
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    try {
      debugPrint('🔄 Fetching health data at: $timestamp');
      await HealthLogic().fetchHealthData();
      await SupabaseDB().insertNotifications();
      await _insertLogRecord('called fetch health');
      await _insertLogRecord('calledNotifcation');
      debugPrint('✅ Health data fetched successfully.');
    } catch (e) {
      debugPrint('❌ Error fetching health data: $e');
    }
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) {
    debugPrint('Foreground service stopped at: $timestamp');
  }
}
