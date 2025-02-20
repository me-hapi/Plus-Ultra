import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lingap/core/const/colors.dart';

class MindfulOverview extends StatelessWidget {
  final Map<String, double> mindfulnessData = {
    'Breathing': 5,
    'Meditation': 8,
    'Relax': 4,
    'Sleep': 10,
  };

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
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
                          title: '', // Removes the text inside the pie sections
                          radius: 80,
                          color: color, // Assigns colors based on the category
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${totalHours.toStringAsFixed(1)} h',
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
                      'Relax': empathyOrange['Orange40'],
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
                        Text('${entry.value.toStringAsFixed(1)} h',
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
          ],
        ),
      ),
    );
  }
}
