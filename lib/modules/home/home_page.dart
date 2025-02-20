import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';
import 'package:lingap/features/wearable_device/ui/health_page.dart';
import 'package:lingap/features/wearable_device/ui/vital_card.dart';
import 'package:lingap/modules/home/greeting_card.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalSupabase supabase = GlobalSupabase(client);
  bool isConnected = false;
  final HealthLogic healthLogic = HealthLogic();
  String? name;
  String? imageUrl;

  Map<String, dynamic> healthDataMap = {};

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _initializeConnectionStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeConnectionStatus();
  }

  Future<void> _initializeConnectionStatus() async {
    final result =
        await SharedPrefHelper.instance.getBool('isConnected') ?? false;

    if (isConnected) {
      await _fetchHealthData();
    }
    setState(() {
      isConnected = result;
    });
  }

  Future<void> _fetchHealthData() async {
    Map<String, dynamic> data = await healthLogic.fetchHealthData();
    setState(() {
      healthDataMap = data;
    });
  }

  Future<void> _fetchProfile() async {
    Map<String, dynamic>? result = await supabase.fetchProfile(uid);
    if (mounted) {
      setState(() {
        name = result!['name'];
        imageUrl = result['imageUrl'];
      });
    }
  }

  final List<FlSpot> sleepData = [
    FlSpot(0, 6.5),
    FlSpot(1, 7),
    FlSpot(2, 6.8),
    FlSpot(3, 7.2),
    FlSpot(4, 6.9),
  ];

  final List<FlSpot> moodData = [
    FlSpot(0, 4),
    FlSpot(1, 5),
    FlSpot(2, 4.5),
    FlSpot(3, 5.2),
    FlSpot(4, 4.8),
  ];

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: name == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  : GreetingCard(
                      name: name!,
                      imageUrl: imageUrl!,
                    ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column for Wearable and its Card
                  Column(
                    children: [
                      Text(
                        'Wearable',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mindfulBrown['Brown80'],
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 220, // Set a fixed height
                        child: Card(
                          color: serenityGreen['Green50'],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 0, left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/vitals/smartwatch.png',
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.contain,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.push('/health-page').then((value) {
                                      _initializeConnectionStatus();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 0),
                                    backgroundColor: mindfulBrown['Brown80'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    isConnected ? 'Connected' : 'Connect',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Column for Mood and its Card
                  Column(
                    children: [
                      Text(
                        'Mindfulness',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mindfulBrown['Brown80']!,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                          height: 220,
                          child: GestureDetector(
                            onTap: () {
                              context.push('/mindful-home');
                            },
                            child: Card(
                              elevation: 0,
                              color: reflectiveBlue['Blue40'],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Icon(
                                  Icons.mood, // Use a mood icon
                                  size: 120,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                'Vitals Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: mindfulBrown['Brown80']!,
                ),
              ),
            ),
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
                VitalCard(
                  title: "Sleep",
                  imageUrl: "assets/vitals/sleep.png",
                  metric: '80',
                  lineGraphData: sleepData,
                  graphColor: mindfulBrown['Brown50']!,
                ),
                VitalCard(
                  title: "Mood",
                  imageUrl: "assets/vitals/mood.png",
                  metric: '80',
                  lineGraphData: moodData,
                  graphColor: reflectiveBlue['Blue50']!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
