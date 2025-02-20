import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class VitalCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String metric;
  final List<FlSpot> lineGraphData;
  final Color graphColor;

  const VitalCard({
    required this.title,
    required this.imageUrl,
    required this.metric,
    required this.lineGraphData,
    required this.graphColor,
    Key? key,
  }) : super(key: key);

  String _getTitleText(String metric) {
    switch (metric) {
      case 'heart rate':
        return 'bpm';
      case 'blood pressure':
        return 'mmHg';
      case 'sleep':
        return 'hr/day';
      case 'mood':
        return 'mood';
      default:
        return ''; // Return an empty string or a default text
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Mood') {
          context.push('/mood-overview');
        }
        if (title == 'Sleep') {
          context.push('/sleep-overview');
        }
      },
      child: Card(
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Left side: Circle Frame with Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(imageUrl),
              ),
              SizedBox(width: 16),
              // Center: Title and Metric
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: mindfulBrown['Brown80'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  lineGraphData.isEmpty
                      ? Text(
                          'No data available yet',
                          style: TextStyle(
                            color: optimisticGray['Gray60'],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Title
                            Text(
                              metric,
                              style: TextStyle(
                                color: mindfulBrown['Brown80'],
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            //Label
                            Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _getTitleText(title.toLowerCase()),
                                  style: TextStyle(
                                    color: optimisticGray['Gray60'],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                ],
              ),
              Spacer(),
              // Right side: Line Graph
              SizedBox(
                height: 50,
                width: 60,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: lineGraphData,
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            graphColor,
                            graphColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false), // Hides the circles
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              graphColor.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: false, // Hides all labels and titles
                    ),
                    borderData: FlBorderData(show: false), // Hides the borders
                    gridData: FlGridData(show: false), // Hides the grid
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
