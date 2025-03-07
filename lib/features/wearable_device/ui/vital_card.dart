import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';

class VitalCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String metric;
  final List<FlSpot> lineGraphData;
  final Color graphColor;

  const VitalCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.metric,
    required this.lineGraphData,
    required this.graphColor,
  }) : super(key: key);

  @override
  _VitalCardState createState() => _VitalCardState();
}

class _VitalCardState extends State<VitalCard> {
  final GlobalSupabase _globalSupabase = GlobalSupabase(client);
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    checkMoodSleep();
  }

  Future<void> checkMoodSleep() async {
    switch (widget.title.toLowerCase()) {
      case 'mood':
        final result = await _globalSupabase.isMoodEmpty();
        // print('MOOD ENTRY: $result');
        setState(() {
          isEmpty = result;
        });
        break;

      case 'sleep':
        final result = await _globalSupabase.isSleepEmpty();
        setState(() {
          isEmpty = result;
        });
        break;
    }
  }

  String _getTitleText(String metric) {
    switch (metric) {
      case 'heart rate':
        return 'bpm';
      case 'blood oxygen':
        return '%';
      case 'sleep':
        return 'hrs/day';
      case 'mood':
        return '';
      default:
        return ''; // Return an empty string or a default text
    }
  }

  @override
  Widget build(BuildContext context) {
    checkMoodSleep();
    return GestureDetector(
      onTap: () {
        if (widget.title == 'Mood') {
          context.push('/mood-overview', extra: widget.lineGraphData);
        }
        if (widget.title == 'Sleep') {
          context.push('/sleep-overview');
        }
        if (widget.title == 'Heart Rate') {
          print('heart');
          context.push('/heart-overview',
              extra: {'heart': widget.lineGraphData, 'average': widget.metric});
        }
        if (widget.title == 'Blood Oxygen') {
          context.push('/oxygen-overview', extra: {
            'oxygen': widget.lineGraphData,
            'average': widget.metric
          });
        }
      },
      child: Card(
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: isEmpty ? empathyOrange['Orange50'] : Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Left side: Circle Frame with Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(widget.imageUrl),
              ),
              SizedBox(width: 16),
              // Center: Title and Metric
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: mindfulBrown['Brown80'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.lineGraphData.isEmpty
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
                              widget.metric,
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
                                  _getTitleText(widget.title.toLowerCase()),
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
                        spots: widget.lineGraphData,
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            widget.graphColor,
                            widget.graphColor,
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
                              widget.graphColor.withOpacity(0.3),
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
