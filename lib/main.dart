import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'router.dart';

// Background task name
const fetchHealthTask = "fetchHealthDataTask";

// Callback function for WorkManager tasks
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == fetchHealthTask) {
      // Perform your background task here
      try {
        // Example: Log the execution
        debugPrint('Background task executed: $fetchHealthTask');
        // Add any logic you need to perform, such as fetching health data
      } catch (e) {
        debugPrint('Error in background task: $e');
      }
      return Future.value(true); // Task completed successfully
    }
    return Future.value(false); // Task failed
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://roklxdmfmwyniafvremi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJva2x4ZG1mbXd5bmlhZnZyZW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5Nzk5MDQsImV4cCI6MjA0NzU1NTkwNH0.zWPFIV5mr6jNwgdU1JHAHQZANHA69qrpTanOcokD5YQ',
  );

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Schedule periodic background tasks
  Workmanager().cancelByTag(fetchHealthTask).then((_) {
    Workmanager().registerOneOffTask(
      fetchHealthTask,
      fetchHealthTask,
      initialDelay: const Duration(seconds: 5),
    );
  });

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
