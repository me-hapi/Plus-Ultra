import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';

class HealthPage extends ConsumerStatefulWidget {
  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends ConsumerState<HealthPage> {
  late HealthLogic healthLogic;

  @override
  void initState() {
    super.initState();
    healthLogic = ref.read(healthLogicProvider.notifier); // Accessing the provider
    _initializeHealthConnect();
  }

  Future<void> _initializeHealthConnect() async {
    await healthLogic.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(healthLogicProvider); // Watching the provider state

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health Connect App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/vitals/smartwatch.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: appState == AppState.CONNECTED ? Colors.green : Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    appState == AppState.CONNECTED
                        ? 'Permission Granted'
                        : 'Idle',
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
        ),
      ),
    );
  }
}
