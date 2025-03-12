import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/ui/mindful_card.dart';
import 'package:lingap/features/sleep_tracker/data/supabase.dart';
import 'package:lingap/features/sleep_tracker/logic/overview_logic.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SleepOverview extends StatefulWidget {
  @override
  _sleepOverviewState createState() => _sleepOverviewState();
}

class _sleepOverviewState extends State<SleepOverview> {
  final SupabaseDB supabase = SupabaseDB(client);
  final OverviewLogic sleepLogic = OverviewLogic();

  @override
  void initState() {
    super.initState();
    sleepLogic.fetchSleepData().then((_) {
      setState(() {}); // Update UI after data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    String sleepQuality =
        sleepLogic.sleepSelection[sleepLogic.sleepIndex]['sleep'];

    return Scaffold(
      body: Stack(
        children: [
          Container(
              color: sleepLogic.sleepSelection[sleepLogic.sleepIndex]['color']),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    sleepLogic.sleepSelection[sleepLogic.sleepIndex]['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Text(
                  'Sleep Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
              SizedBox(height: 30),
              Center(
                child: Image.asset(
                  sleepLogic.sleepSelection[sleepLogic.sleepIndex]['icon'],
                  height: 120,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'I have a $sleepQuality sleep \n this week.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height,
                    ),
                    painter: ConvexArcPainter(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 400,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sleep Report',
                                style: TextStyle(
                                  color: mindfulBrown['Brown80'],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                child: _buildCard(
                                  title: 'Average Sleep',
                                  value: sleepLogic.avgSleep,
                                  color: serenityGreen['Green50']!,
                                ),
                              ),
                              SizedBox(width: 5), // Adjust spacing as needed
                              Expanded(
                                child: _buildCard(
                                  title: 'Sleep Debt',
                                  value: sleepLogic.sleepDebt,
                                  color: empathyOrange['Orange50']!,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    left: MediaQuery.of(context).size.width / 2 - 40,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/sleep-track');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: mindfulBrown['Brown80'],
                      ),
                      child: Icon(
                        color: Colors.white,
                        Icons.add,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ConvexArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mindfulBrown['Brown10']!
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 30)
      ..quadraticBezierTo(
        size.width / 2,
        -30,
        size.width,
        30,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget _buildCard({
  required String title,
  required double value,
  required Color color,
  double width = 170, // Default width
  double height = 220, // Default height
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    color: Colors.white,
    elevation: 0.0,
    child: SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mindfulBrown['Brown80'],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width * 0.7, // Make sure it scales properly
                  height: width * 0.7,
                  child: CircularProgressIndicator(
                    value: value / 12.0,
                    strokeWidth: 15.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  '${value.toStringAsFixed(2)} h',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: mindfulBrown['Brown80'],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
