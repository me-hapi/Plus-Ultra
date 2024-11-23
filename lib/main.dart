import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://roklxdmfmwyniafvremi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJva2x4ZG1mbXd5bmlhZnZyZW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5Nzk5MDQsImV4cCI6MjA0NzU1NTkwNH0.zWPFIV5mr6jNwgdU1JHAHQZANHA69qrpTanOcokD5YQ',
  );
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: goRouter,
    );
  }
}
