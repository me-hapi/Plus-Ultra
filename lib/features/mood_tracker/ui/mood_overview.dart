import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/ui/mindful_card.dart';
import 'package:lingap/features/mood_tracker/data/supabase_db.dart';
import 'package:lingap/features/mood_tracker/logic/overview_logic.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MoodOverview extends StatefulWidget {
  @override
  _MoodOverviewState createState() => _MoodOverviewState();
}

class _MoodOverviewState extends State<MoodOverview> {
  final SupabaseDB supabase = SupabaseDB(client);
  final OverviewLogic moodLogic = OverviewLogic();

  @override
  void initState() {
    super.initState();
    moodLogic.fetchMoodData().then((_) {
      setState(() {}); // Update UI after data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    String moodWeek = moodLogic.moodSelection[moodLogic.weekMood]['mood'];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: moodLogic.moodSelection[moodLogic.weekMood]['color'],
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    moodLogic.moodSelection[moodLogic.weekMood]['image']),
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
                  'Mood Overview',
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
                  moodLogic.moodSelection[moodLogic.weekMood]['icon'],
                  height: 120,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'I am feeling $moodWeek \n this week.',
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
                                'Mood History',
                                style: TextStyle(
                                  color: mindfulBrown['Brown80'],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Column(
                                    children: List.generate(5, (index) {
                                      return Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.grey.shade300,
                                                  thickness: 1,
                                                  endIndent: 10,
                                                  indent: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(7, (index) {
                                    int weekday = index + 1;
                                    int moodIndex =
                                        moodLogic.moodData[weekday] ?? -1;
                                    if (moodIndex >= 0) {
                                      Map mood =
                                          moodLogic.moodSelection[moodIndex];

                                      return _buildBar(
                                        value: mood['value'],
                                        icon: mood['icon'],
                                        color: mood['color'],
                                        day: moodLogic.getDayLabel(weekday),
                                      );
                                    } else {
                                      return _buildBar(
                                        value: 0,
                                        icon: 'assets/journal/ekis.png',
                                        color: mindfulBrown['Brown80']!,
                                        day: moodLogic.getDayLabel(weekday),
                                      );
                                    }
                                  }),
                                )
                              ],
                            ),
                          ),
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
                        context.push('/mood-track');
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

Widget _buildBar({
  required String day,
  required int value,
  required String icon,
  required Color color,
}) {
  double barHeight = (value / 5) * 270;

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 40,
        height: barHeight.clamp(0.0, 260.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 30,
                  child: Image.asset(
                    icon,
                    height: 20,
                    width: 20,
                  ),
                )),
          ],
        ),
      ),
      Text(day)
    ],
  );
}
