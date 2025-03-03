import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/data/supabase.dart';

class MindfulOverview extends StatefulWidget {
  const MindfulOverview({Key? key}) : super(key: key);

  @override
  _MindfulOverviewState createState() => _MindfulOverviewState();
}

class _MindfulOverviewState extends State<MindfulOverview> {
  Map<String, double> mindfulnessData = {
    'Breathing': 0,
    'Relaxation': 0,
    'Sleep': 0,
    'Meditation': 0,
  };
  final SupabaseDB supabase = SupabaseDB(client);

  void initState() {
    super.initState();
    fetchMindfulness();
  }

  Future<void> fetchMindfulness() async {
    final result = await supabase.fetchMindfulness();
    setState(() {
      mindfulnessData = convert(result);
    });
  }

  Map<String, double> convert(List<Map<String, dynamic>> result) {
    // Initialize exercise totals (in seconds)
    Map<String, int> exerciseSeconds = {
      'Breathing': 0,
      'Relaxation': 0,
      'Sleep': 0,
      'Meditation': 0,
    };

    // Sum up total seconds for each exercise category
    for (var entry in result) {
      String exerciseType =
          entry['exercise'] ?? ''; // Ensure exercise key exists
      int minutes = entry['minutes'] ?? 0;
      int seconds = entry['seconds'] ?? 0;

      if (exerciseSeconds.containsKey(exerciseType)) {
        exerciseSeconds[exerciseType] =
            exerciseSeconds[exerciseType]! + (minutes * 60) + seconds;
      }
    }

    // Convert total seconds to hours (double)
    Map<String, double> exerciseHours = {
      for (var key in exerciseSeconds.keys)
        key: exerciseSeconds[key]! / 3600 // Convert seconds to hours
    };

    return exerciseHours;
  }

  @override
  Widget build(BuildContext context) {
    double totalHours = mindfulnessData.values.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mindful Overview',
          style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 24),
        ),
        backgroundColor: mindfulBrown['Brown10'],
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: mindfulnessData.entries.map((entry) {
                          final color = {
                                'Breathing': serenityGreen['Green50'],
                                'Meditation': zenYellow['Yellow50'],
                                'Relax': empathyOrange['Orange40'],
                                'Sleep': mindfulBrown['Brown80'],
                              }[entry.key] ??
                              Colors.grey;

                          return PieChartSectionData(
                            value: entry.value,
                            title:
                                '', // Removes the text inside the pie sections
                            radius: 70,
                            color:
                                color, // Assigns colors based on the category
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${totalHours.toStringAsFixed(2)} h',
                        style: TextStyle(
                            color: mindfulBrown['Brown80'],
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                            color: mindfulBrown['Brown80'], fontSize: 24),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: mindfulnessData.entries.map((entry) {
                double percentage = (entry.value / totalHours) * 100;
                final color = {
                      'Breathing': serenityGreen['Green50'],
                      'Meditation': zenYellow['Yellow50'],
                      'Relaxation': empathyOrange['Orange40'],
                      'Sleep': mindfulBrown['Brown80'],
                    }[entry.key] ??
                    Colors.grey;

                return Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                            child: Text(entry.key,
                                style: TextStyle(
                                    color: mindfulBrown['Brown80'],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        Text('${entry.value.toStringAsFixed(2)} h',
                            style: TextStyle(
                                fontSize: 16, color: optimisticGray['Gray40'])),
                        SizedBox(width: 10),
                        Text('${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                                fontSize: 16, color: mindfulBrown['Brown80'])),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  
}


