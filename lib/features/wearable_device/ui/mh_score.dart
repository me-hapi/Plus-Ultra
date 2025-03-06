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

  List<FlSpot> filteredDepression = [];
  List<FlSpot> filteredAnxiety = [];
  List<FlSpot> filteredStress = [];
  @override
  void initState() {
    super.initState();
    filterData();
  }

  void filterData() {
    filteredDepression =
        getFilteredData(convertTimestamps(widget.depressionGraph));
    filteredAnxiety = getFilteredData(convertTimestamps(widget.anxietyGraph));
    filteredStress = getFilteredData(convertTimestamps(widget.stressGraph));
  }

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

  // List<FlSpot> normalizeTimestamps(List<FlSpot> data) {
  //   if (data.isEmpty) return [];

  //   double minX = data.first.x; // Get the earliest timestamp

  //   return data.map((spot) => FlSpot(spot.x - minX, spot.y)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    print("Filtered Depression Data: $filteredDepression");

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Title
                CircleAvatar(
                  radius: 8,
                  backgroundColor: kindPurple['Purple50'],
                ),
                Text(
                  '${widget.depression.toString()}%',
                  style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontSize: 32,
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
                      widget.depression == 0
                          ? '- '
                          : widget.depression > 0
                              ? '↑  '
                              : '↓  ',
                      style: TextStyle(
                        color: widget.depression == 0
                            ? optimisticGray['Gray50']
                            : widget.depression > 0
                                ? presentRed['Red50']
                                : serenityGreen['Green50'],
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                //Title
                CircleAvatar(
                  radius: 8,
                  backgroundColor: empathyOrange['Orange50'],
                ),
                Text(
                  '${widget.anxiety.toString()}%',
                  style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontSize: 32,
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
                      widget.anxiety == 0
                          ? '- '
                          : widget.anxiety > 0
                              ? '↑  '
                              : '↓  ',
                      style: TextStyle(
                        color: widget.anxiety == 0
                            ? optimisticGray['Gray50']
                            : widget.anxiety > 0
                                ? presentRed['Red50']
                                : serenityGreen['Green50'],
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                //Title
                CircleAvatar(
                  radius: 8,
                  backgroundColor: serenityGreen['Green50'],
                ),
                Text(
                  '${widget.stress.toString()}%',
                  style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontSize: 32,
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
                      widget.stress == 0
                          ? '- '
                          : widget.stress > 0
                              ? '↑ '
                              : '↓ ',
                      style: TextStyle(
                        color: widget.stress == 0
                            ? optimisticGray['Gray50']
                            : widget.stress > 0
                                ? presentRed['Red50']
                                : serenityGreen['Green50'],
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: LineChart(mainData(
                      filteredDepression, filteredAnxiety, filteredStress)),
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
          filterData();
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

  LineChartData mainData(
      List<FlSpot> depression, List<FlSpot> anxiety, List<FlSpot> stress) {
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
            interval: 3,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: filteredDepression.isNotEmpty ? filteredDepression.first.x : 0,
      maxX: filteredDepression.isNotEmpty ? filteredDepression.last.x : 1,
      minY: 0,
      maxY: 12,
      lineBarsData: [
        LineChartBarData(
          spots: depression,
          isCurved: true,
          color: kindPurple['Purple50'],
          barWidth: 4,
        ),
        LineChartBarData(
          spots: anxiety,
          isCurved: true,
          color: empathyOrange['Orange50'],
          barWidth: 4,
        ),
        LineChartBarData(
          spots: stress,
          isCurved: true,
          color: serenityGreen['Green50'],
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
