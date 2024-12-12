import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class VitalCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String metric;
  final List<FlSpot> lineGraphData;

  const VitalCard({
    required this.title,
    required this.imageUrl,
    required this.metric,
    required this.lineGraphData,
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
    return Card(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Left side: Circle Frame with Avatar
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Circle Frame
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBE7E4),
                      ),
                    ),
                    // Image inside
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage(imageUrl), 
                    ),
                  ],
                ),
              ],
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
                    color: Color(0xFF473c38),
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Title
                    Text(
                      metric,
                      style: TextStyle(
                        color: Color(0xFF473c38),
                        fontFamily: 'Montserrat',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    //Label
                    Text(
                      _getTitleText(title.toLowerCase()),
                      style: TextStyle(
                        color: Color(0xFF473c38),
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                          Colors.blue.withOpacity(0.8),
                          Colors.blue.withOpacity(0.8),
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
                            Colors.blue.withOpacity(0.3),
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
    );
  }
}
