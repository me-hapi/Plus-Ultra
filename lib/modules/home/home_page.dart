import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/wearable_device/ui/vital_card.dart';
import 'package:lingap/modules/home/greeting_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
      backgroundColor: const Color(0xFFEBE7E4),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Wearable',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Color(0xFF473c38),
                    ),
                  ),
                  const SizedBox(width: 90),
                  const Text(
                    'Mood',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Color(0xFF473c38),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 5),
                SizedBox(
                  height: 220, // Set a fixed height
                  child: Card(
                    color: Color(0xFFB2B682),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 18, right: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center content vertically
                        children: [
                          Image.asset(
                            'assets/vitals/smartwatch.png',
                            height: 120, 
                            width: 120, 
                            fit: BoxFit
                                .contain,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              print('Connect button clicked');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 0),
                            ),
                            child: const Text(
                              'Connect',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xFFB2B682),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: Card(
                    elevation: 0,
                    color: Color(0xFFD1C8F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.mood, // Use a mood icon
                        size: 120,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: const Text(
                'Vitals Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF473c38),
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
                ),
                VitalCard(
                  title: "Blood Pressure",
                  imageUrl: "assets/vitals/blood.png",
                  metric: '80',
                  lineGraphData: bloodPressureData,
                ),
                VitalCard(
                  title: "Sleep",
                  imageUrl: "assets/vitals/sleep.png",
                  metric: '80',
                  lineGraphData: sleepData,
                ),
                VitalCard(
                  title: "Mood",
                  imageUrl: "assets/vitals/mood.png",
                  metric: '80',
                  lineGraphData: moodData,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
