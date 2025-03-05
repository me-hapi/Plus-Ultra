import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/data/supabase.dart';
import 'package:lingap/features/mindfulness/services/recommender_api.dart';
import 'package:lingap/features/mindfulness/ui/mindful_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecommenderApi recommender = RecommenderApi();
  final SupabaseDB supabase = SupabaseDB(client);
  List<Map<String, dynamic>> mindfulHistory = [];
  int total = 0;
  @override
  void initState() {
    super.initState();
    fetchMindfulness();
  }

  Future<void> fetchMindfulness() async {
    final result = await supabase.fetchMindfulness();
    setState(() {
      total = getTotalDuration(result);
      mindfulHistory = result;
    });
    print(mindfulHistory);
  }

  int getTotalDuration(List<Map<String, dynamic>> result) {
    int totalSeconds = 0;

    for (var entry in result) {
      int minutes = entry['minutes'] ?? 0;
      int seconds = entry['seconds'] ?? 0;

      totalSeconds += (minutes * 60) + seconds;
    }

    return (totalSeconds / 60).toInt();
  }

  List<Widget> buildMindfulCards() {
    return mindfulHistory.map((mindful) {
      return MindfulCard(
        goal: mindful['goal'] ?? 'No goal specified',
        song: mindful['soundtracks']['name'] ?? 'No song selected',
        minutes: mindful['minutes'],
        seconds: mindful['seconds'],
        exercise: mindful['exercise'] ?? 'Uncategorized',
        url: mindful['soundtracks']['url'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Color overlay
      Container(
        color: reflectiveBlue['Blue50'],
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mindfulness/bg.png'),
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left-aligned GestureDetector (Back Button)
                GestureDetector(
                  onTap: () {
                    context.push('/bottom-nav', extra: 0);
                  },
                  child: Image.asset(
                    'assets/utils/whiteBack.png',
                    width: 25,
                    height: 25,
                  ),
                ),

                // Centered Text
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Mindful Minutes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Invisible Spacer to balance row layout
                SizedBox(width: 10), // Same width as the back button
              ],
            ),
            centerTitle: true,
          ),
          // Upper Section: Open Book Icon and Journal Count

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/mindfulness/time.png', height: 60),
              SizedBox(width: 8),
              Text(
                total.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 150,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'Mindful minutes this year',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Spacer(),
          // Floating Plus Button

          Stack(
            clipBehavior: Clip.none,
            children: [
              // CustomPaint Background
              CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: ConvexArcPainter(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 360,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mindful Hour History',
                            style: TextStyle(
                              color: mindfulBrown['Brown80'],
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push('/mindful-overview');
                            },
                            child: Image.asset(
                              'assets/journal/more.png',
                              height: 50,
                              width: 50,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: buildMindfulCards(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Elevated Button at the Top
              Positioned(
                top: -40, // Adjust the top value to overlap the button
                left: MediaQuery.of(context).size.width / 2 -
                    40, // Center horizontally
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/new-exercise');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: mindfulBrown['Brown80']),
                  child: Icon(
                    color: Colors.white,
                    Icons.add,
                    size: 50,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ]));
  }
}

class LegendItem extends StatelessWidget {
  final Color? color;
  final String label;

  const LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
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
      ..moveTo(0, 30) // Start slightly below the top edge
      ..quadraticBezierTo(
        size.width / 2, // Control point x
        -30, // Control point y (above the canvas for a convex arc)
        size.width, // End point x
        30, // End point y
      )
      ..lineTo(size.width, size.height) // Go to the bottom right
      ..lineTo(0, size.height) // Go to the bottom left
      ..close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
