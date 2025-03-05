import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class MhScorePage extends StatefulWidget {
  final int depression;
  final int anxiety;
  final int stress;
  final List<FlSpot> depressionGraph;
  final List<FlSpot> anxietyGraph;
  final List<FlSpot> stressGraph;

  const MhScorePage({
    Key? key,
    required this.depression,
    required this.anxiety,
    required this.stress,
    required this.depressionGraph,
    required this.anxietyGraph,
    required this.stressGraph,
  }) : super(key: key);

  @override
  MhScorePageState createState() => MhScorePageState();
}

class MhScorePageState extends State<MhScorePage> {
  int _selectedIndex = 1;
  final List<String> _options = ["1 day", "1 week", "1 month", "1 year", "All"];

  List<FlSpot> convertTimestamps(List<FlSpot> data) {
    return data.map((spot) => FlSpot(spot.x / 1e3, spot.y)).toList();
  }

  List<FlSpot> getFilteredData(List<FlSpot> data) {
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
        return data;
    }

    double startTimestamp = startDate.millisecondsSinceEpoch / 1e3;
    return data.where((spot) => spot.x >= startTimestamp).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> filteredDepression = getFilteredData(convertTimestamps(widget.depressionGraph));
    List<FlSpot> filteredAnxiety = getFilteredData(convertTimestamps(widget.anxietyGraph));
    List<FlSpot> filteredStress = getFilteredData(convertTimestamps(widget.stressGraph));

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
            SizedBox(width: 5),
            Text(
              "Mental Health Scores",
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
            Spacer(),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: LineChart(mainData(filteredDepression, filteredAnxiety, filteredStress)),
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

  LineChartData mainData(List<FlSpot> depression, List<FlSpot> anxiety, List<FlSpot> stress) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 3,
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
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: leftTitleWidgets,
            interval: 3,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: 0,
      maxX: DateTime.now().millisecondsSinceEpoch / 1e3,
      minY: 0,
      maxY: 12,
      lineBarsData: [
        LineChartBarData(
          spots: depression,
          isCurved: true,
          color: Colors.purple,
          barWidth: 4,
        ),
        LineChartBarData(
          spots: anxiety,
          isCurved: true,
          color: Colors.orange,
          barWidth: 4,
        ),
        LineChartBarData(
          spots: stress,
          isCurved: true,
          color: Colors.green,
          barWidth: 4,
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 3 != 0) return Container();
    return Text("${value.toInt()}",
        style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 16),
        textAlign: TextAlign.left);
  }
}
