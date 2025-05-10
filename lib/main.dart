import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
import 'package:lingap/features/wearable_device/logic/foreground_service.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';
import 'package:lingap/features/wearable_device/model/stress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router.dart';

final Health health = Health();

Future<bool> requestPermissions() async {
  try {
    health.configure();

    final types = [HealthDataType.HEART_RATE, HealthDataType.BLOOD_OXYGEN];

    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    bool granted =
        await health.requestAuthorization(types, permissions: permissions);

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.instance.init();
  await Supabase.initialize(
    url: '',
    anonKey:
        '',
  );
  await requestPermissions();
  bool isRunning = await FlutterForegroundTask.isRunningService;
  print("Foreground service running: $isRunning");

  ForegroundHealthService.startForegroundService();


  runApp(const ProviderScope(child: LingapApp()));
}

class LingapApp extends ConsumerWidget {
  const LingapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Lingap',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Urbanist',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          titleLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          bodyMedium: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
      ),
      routerConfig: goRouter,
    );
  }
}
