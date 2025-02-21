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
  Map<String, dynamic> moodData = {};
  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _initializeConnectionStatus();
    _fetchSleepData();
    _fetchMoodData();
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
    if (mounted) {
      setState(() {
        name = result!['name'];
        imageUrl = result['imageUrl'];
      });
    }
  }

  Future<void> _fetchSleepData() async {
    final result = await homeLogic.fetchSleep();
    setState(() {
      sleepData = result;
    });
  }

  Future<void> _fetchMoodData() async {
    final result = await homeLogic.fetchMood();
    setState(() {
      moodData = result;
    });
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
                  lineGraphData: sleepData['spots'] ?? [],
                  graphColor: mindfulBrown['Brown50']!,
                ),
                VitalCard(
                  title: "Mood",
                  imageUrl: "assets/vitals/mood.png",
                  metric: moodData['average'].toString(),
                  lineGraphData: moodData['spots'] ?? [],
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
