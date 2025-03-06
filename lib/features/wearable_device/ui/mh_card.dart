import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class MhCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int depression;
  final int anxiety;
  final int stress;
  final List<FlSpot> depressionGraph;
  final List<FlSpot> anxietyGraph;
  final List<FlSpot> stressGraph;

  const MhCard({
    required this.title,
    required this.imageUrl,
    Key? key,
    required this.depression,
    required this.anxiety,
    required this.stress,
    required this.depressionGraph,
    required this.anxietyGraph,
    required this.stressGraph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/mh-overview', extra: {
          'depression': depression,
          'anxiety': anxiety,
          'stress': stress,
          'depressionGraph': depressionGraph,
          'anxietyGraph': anxietyGraph,
          'stressGraph': stressGraph,
        });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Title
                      Text(
                        '${depression.toString()}%',
                        style: TextStyle(
                          color: mindfulBrown['Brown80'],
                          fontSize: 14,
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
                            depression == 0
                                ? '- '
                                : depression > 0
                                    ? '↑ '
                                    : '↓ ',
                            style: TextStyle(
                              color: depression == 0
                                  ? optimisticGray['Gray50']
                                  : depression > 0
                                      ? presentRed['Red50']
                                      : serenityGreen['Green50'],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      //Title
                      Text(
                        '${anxiety.toString()}%',
                        style: TextStyle(
                          color: mindfulBrown['Brown80'],
                          fontSize: 14,
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
                            anxiety == 0
                                ? '- '
                                : anxiety > 0
                                    ? '↑ '
                                    : '↓ ',
                            style: TextStyle(
                              color: anxiety == 0
                                  ? optimisticGray['Gray50']
                                  : anxiety > 0
                                      ? presentRed['Red50']
                                      : serenityGreen['Green50'],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      //Title
                      Text(
                        '${stress.toString()}%',
                        style: TextStyle(
                          color: mindfulBrown['Brown80'],
                          fontSize: 14,
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
                            stress == 0
                                ? '- '
                                : stress > 0
                                    ? '↑ '
                                    : '↓ ',
                            style: TextStyle(
                              color: stress == 0
                                  ? optimisticGray['Gray50']
                                  : stress > 0
                                      ? presentRed['Red50']
                                      : serenityGreen['Green50'],
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
                        spots: depressionGraph,
                        isCurved: true,
                        color: kindPurple['Purple50'],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false), // Hides the circles
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              kindPurple['Purple50']!.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      LineChartBarData(
                        spots: anxietyGraph,
                        isCurved: true,
                        color: empathyOrange['Orange50'],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false), // Hides the circles
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              empathyOrange['Orange50']!.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      LineChartBarData(
                        spots: stressGraph,
                        isCurved: true,
                        color: serenityGreen['Green50'],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false), // Hides the circles
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              serenityGreen['Green50']!.withOpacity(0.3),
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
