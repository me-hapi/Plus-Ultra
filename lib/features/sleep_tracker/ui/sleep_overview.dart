import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/ui/mindful_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SleepOverview extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SleepOverview> {
  List<Map<String, dynamic>> moodSelection = [
    {
      'mood': 'cheerful',
      'color': serenityGreen['Green50'],
      'image': 'assets/tracker/darkGreen.png'
    },
    {
      'mood': 'happy',
      'color': zenYellow['Yellow50'],
      'image': 'assets/tracker/darkYellow.png'
    },
    {
      'mood': 'neutral',
      'color': mindfulBrown['Brown50'],
      'image': 'assets/tracker/darkBrown.png'
    },
    {
      'mood': 'sad',
      'color': empathyOrange['Orange50'],
      'image': 'assets/tracker/darkOrange.png'
    },
    {
      'mood': 'awful',
      'color': reflectiveBlue['Blue50'],
      'image': 'assets/tracker/darkBlue.png'
    },
  ];

  @override
  void initState() {
    super.initState();
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
          // Upper Section: Open Book Icon and Journal Count

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/mindfulness/time.png', height: 60),
              SizedBox(width: 8),
              Text(
                '25',
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
                            'Mood History',
                            style: TextStyle(
                              color: mindfulBrown['Brown80'],
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
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
