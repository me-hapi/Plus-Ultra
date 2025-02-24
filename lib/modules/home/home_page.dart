import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
import 'package:lingap/features/wearable_device/data/supabase_db.dart';
import 'package:lingap/features/wearable_device/logic/health_connect.dart';
import 'package:lingap/features/wearable_device/ui/health_page.dart';
import 'package:lingap/features/wearable_device/ui/vital_card.dart';
import 'package:lingap/modules/home/greeting_card.dart';
import 'package:lingap/modules/home/home_logic.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalSupabase supabase = GlobalSupabase(client);
  final SupabaseDB supabaseV = SupabaseDB();
  bool isConnected = false;
  final HealthLogic healthLogic = HealthLogic();
  String? name;
  String? imageUrl;
  final HomeLogic homeLogic = HomeLogic();
  Map<String, dynamic> healthDataMap = {};
  Map<String, dynamic> sleepData = {};
  List<FlSpot> sleepBack = [];
  Map<String, dynamic> moodData = {};
  List<FlSpot> moodBack = [];
  double totalHours = 0.0;
  Map<String, double> mindfulnessData = {
    'Breathing': 0,
    'Relaxation': 0,
    'Sleep': 0,
    'Meditation': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _initializeConnectionStatus();
    _fetchSleepData();
    _fetchMoodData();
    _fetchMindfulData();
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

    if (mounted) {
      setState(() {
        isConnected = result;
      });
    }
  }

  Future<void> _fetchHealthData() async {
    final data = await supabaseV.fetchVitalData();
    if (data.isEmpty) {
      print('No health data found.');
      return;
    }

    final result = homeLogic.convertData(data);
    setState(() {
      healthDataMap = result;
    });
  }

  Future<void> _fetchProfile() async {
    Map<String, dynamic>? result = await supabase.fetchProfile(uid);
    if (result == null) {
      if (mounted) {
        context.go('/data');
      }
      return;
    }
    if (mounted) {
      setState(() {
        name = result!['name'];
        imageUrl = result['imageUrl'];
      });
    }
  }

  Future<void> _fetchSleepData() async {
    final result = await homeLogic.fetchSleep();
    if (mounted) {
      setState(() {
        sleepData = result;
      });
    }
  }

  Future<void> _fetchMoodData() async {
    final result = await homeLogic.fetchMood();
    if (mounted) {
      setState(() {
        moodData = result;
      });
    }
  }

  Future<void> _fetchMindfulData() async {
    final result = await homeLogic.fetchMindfulness();
    if (mounted) {
      setState(() {
        mindfulnessData = result;
        totalHours = mindfulnessData.values.reduce((a, b) => a + b);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            color: reflectiveBlue['Blue30'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                width:
                                    140, // Ensures Stack has defined constraints
                                height: 140,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (totalHours > 0)
                                      SizedBox(
                                        // Prevents infinite size error for PieChart
                                        width: 140,
                                        height: 140,
                                        child: PieChart(
                                          PieChartData(
                                            sections: mindfulnessData.entries
                                                .map((entry) {
                                              final color = {
                                                    'Breathing': serenityGreen[
                                                        'Green50'],
                                                    'Meditation':
                                                        zenYellow['Yellow50'],
                                                    'Relaxation': empathyOrange[
                                                        'Orange40'],
                                                    'Sleep':
                                                        mindfulBrown['Brown80'],
                                                  }[entry.key] ??
                                                  Colors.grey;

                                              return PieChartSectionData(
                                                value: entry.value,
                                                title: '',
                                                radius:
                                                    25, // Ensure a reasonable radius
                                                color: color,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    else
                                      const Center(
                                        child: Text(
                                          'No data available yet',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                    // Centered Text
                                    if (totalHours > 0)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${totalHours.toStringAsFixed(2)} h',
                                            style: TextStyle(
                                              color: mindfulBrown['Brown80'],
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              color: mindfulBrown['Brown80'],
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                  metric: healthDataMap['HEART_RATE']?['latest'] ?? 'N/A',
                  lineGraphData: healthDataMap['HEART_RATE']?['spots'] ?? [],
                  graphColor: presentRed['Red50']!,
                ),
                VitalCard(
                  title: "Blood Pressure",
                  imageUrl: "assets/vitals/blood.png",
                  metric: healthDataMap['BLOOD_PRESSURE']?['latest'] ?? 'N/A',
                  lineGraphData:
                      healthDataMap['BLOOD_PRESSURE']?['spots'] ?? [],
                  graphColor: empathyOrange['Orange50']!,
                ),
                VitalCard(
                  title: "Sleep",
                  imageUrl: "assets/vitals/sleep.png",
                  metric: sleepData['average'].toString(),
                  lineGraphData: sleepData.isEmpty
                      ? sleepBack
                      : (sleepData['spots'] as List<dynamic>)
                          .map((e) => e as FlSpot)
                          .toList(),
                  graphColor: mindfulBrown['Brown50']!,
                ),
                VitalCard(
                  title: "Mood",
                  imageUrl: "assets/vitals/mood.png",
                  metric: moodData['average'].toString(),
                  lineGraphData: moodData.isEmpty
                      ? moodBack
                      : (moodData['spots'] as List<dynamic>)
                          .map((e) => e as FlSpot)
                          .toList(),
                  graphColor: kindPurple['Purple50']!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
