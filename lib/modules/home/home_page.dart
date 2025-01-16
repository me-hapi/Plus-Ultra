import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/wearable_device/ui/health_page.dart';
import 'package:lingap/features/wearable_device/ui/vital_card.dart';
import 'package:lingap/modules/home/greeting_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // final HealthConnectService health = HealthConnectService();
  // Dummy data for the line graph
  final List<FlSpot> heartRateData = [
    FlSpot(0, 75),
    FlSpot(1, 80),
    FlSpot(2, 78),
    FlSpot(3, 82),
    FlSpot(4, 79),
  ];

  final List<FlSpot> bloodPressureData = [
    FlSpot(0, 120),
    FlSpot(1, 115),
    FlSpot(2, 118),
    FlSpot(3, 122),
    FlSpot(4, 117),
  ];

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
              child: GreetingCard(),
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
                                top: 10, bottom: 10, left: 30, right: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/vitals/smartwatch.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HealthPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 0),
                                    backgroundColor: mindfulBrown['Brown80'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Connect',
                                    style: TextStyle(
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
                        'Mood',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mindfulBrown['Brown80']!,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 220,
                        child: Card(
                          elevation: 0,
                          color: kindPurple['Purple40'],
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
                  metric: '80',
                  lineGraphData: heartRateData,
                  graphColor: presentRed['Red50']!,
                ),
                VitalCard(
                  title: "Blood Pressure",
                  imageUrl: "assets/vitals/blood.png",
                  metric: '80',
                  lineGraphData: bloodPressureData,
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
