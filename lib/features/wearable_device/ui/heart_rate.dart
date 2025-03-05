import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';

class HeartRatePage extends StatefulWidget {
  final List<FlSpot> heartData;
  final String average;

  const HeartRatePage(
      {Key? key, required this.heartData, required this.average})
      : super(key: key);

  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  late List<FlSpot> convertedHeartData;
  int _selectedIndex = 1;
  final List<String> _options = ["1 day", "1 week", "1 month", "1 year", "All"];

  @override
  void initState() {
    super.initState();
    print('HEARTDATA ${widget.heartData}');
    convertedHeartData = widget.heartData.map((spot) {
      return FlSpot(spot.x / 1e9, spot.y);
    }).toList();
  }

  List<FlSpot> getFilteredData() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (_selectedIndex) {
      case 0:
        startDate = now.subtract(Duration(days: 1));
        break;
      case 1:
        startDate = now.subtract(Duration(days: 7));
        break;
      case 2:
        startDate = now.subtract(Duration(days: 30));
        break;
      case 3:
        startDate = now.subtract(Duration(days: 365));
        break;
      default:
        return convertedHeartData;
    }

    double startTimestamp = startDate.millisecondsSinceEpoch / 1e9;
    return convertedHeartData
        .where((spot) => spot.x >= startTimestamp)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> filteredData = getFilteredData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown10'],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.push('/bottom-nav');
              },
              child: Image.asset(
                'assets/utils/brownBack.png',
                width: 20,
                height: 20,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Heart Rate",
              style: TextStyle(fontSize: 24, color: mindfulBrown['Brown80']),
            )
          ],
        ),
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/utils/heart.png', width: 30, height: 30),
                SizedBox(width: 10),
                Text(widget.average,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                        color: mindfulBrown['Brown80'])),
                Text('BPM',
                    style: TextStyle(
                        fontSize: 36, color: optimisticGray['Gray50']))
              ],
            ),
            Spacer(),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: LineChart(
                      mainData(filteredData.isNotEmpty ? filteredData : [])),
                ),
                Positioned(bottom: 20, child: dateSelector())
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dateSelector() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_options.length, (index) {
          return _buildButton(index);
        }),
      ),
    );
  }

  Widget _buildButton(int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? serenityGreen['Green50'] : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          _options[index],
          style: TextStyle(
              color: isSelected ? Colors.white : optimisticGray['Gray50'],
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ),
    );
  }

  LineChartData mainData(List<FlSpot> data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 30,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: leftTitleWidgets,
            interval: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: data.isNotEmpty ? data.first.x : 0,
      maxX: data.isNotEmpty ? data.last.x : 1,
      minY: 0,
      maxY: 150,
      lineBarsData: data.isNotEmpty
          ? [
              LineChartBarData(
                spots: data,
                isCurved: true,
                color: presentRed['Red50'],
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      presentRed['Red50']!.withOpacity(0.5),
                      presentRed['Red10']!.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ]
          : [],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 30 != 0) return Container();
    return Text("${value.toInt()}",
        style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 16),
        textAlign: TextAlign.left);
  }
}
