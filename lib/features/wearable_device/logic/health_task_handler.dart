import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';

class HealthTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    print("🟢 Foreground Task Started!");

    // Initialize Supabase inside the background isolate
    await Supabase.initialize(
      url: 'https://roklxdmfmwyniafvremi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJva2x4ZG1mbXd5bmlhZnZyZW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5Nzk5MDQsImV4cCI6MjA0NzU1NTkwNH0.zWPFIV5mr6jNwgdU1JHAHQZANHA69qrpTanOcokD5YQ',
    );

    // Fetch health data every 15 minutes
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        print("🔄 Fetching health data...");
        await HealthLogic().fetchHealthData();
        debugPrint("✅ Health data fetched successfully.");
      } catch (e) {
        print("❌ Error fetching health data: $e");
      }
    });
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) {
    print("🛑 Foreground Task Stopped.");
  }

  // 🚨 FIX: Add this required method
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    print("🔄 onRepeatEvent triggered at $timestamp");
  }
}
