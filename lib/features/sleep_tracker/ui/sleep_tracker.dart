import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mood_tracker/data/supabase_db.dart';
import 'package:lingap/features/mood_tracker/ui/mood_modal.dart';

class SleepTracker extends StatefulWidget {
  const SleepTracker({Key? key}) : super(key: key);

  @override
  _DisplayMoodState createState() => _DisplayMoodState();
}

class _DisplayMoodState extends State<SleepTracker> {
  final SupabaseDB supabase = SupabaseDB(client);
  List<Color> bgcolors = [
    kindPurple['Purple40']!,
    empathyOrange['Orange40']!,
    mindfulBrown['Brown60']!,
    zenYellow['Yellow40']!,
    serenityGreen['Green50']!
  ];

  final List<String> moods = [
    "Awful",
    "Sad",
    "Neutral",
    "Happy",
    "Cheerful",
  ];

  final List<String> emojiPaths = [
    'assets/lightMoods/lightAwful.png',
    'assets/lightMoods/lightSad.png',
    'assets/lightMoods/lightNeutral.png',
    'assets/lightMoods/lightHappy.png',
    'assets/lightMoods/lightCheerful.png',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolors[selectedIndex],
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "How are you feeling today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 100),
              Image.asset(
                emojiPaths[selectedIndex],
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "I feel ${moods[selectedIndex]}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 80),
              CustomSlider(
                itemCount: moods.length,
                onSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                selectedIndex: selectedIndex,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await supabase.insertOrUpdateMood(moods[selectedIndex]);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MoodModal(mood: moods[selectedIndex]);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Set Mood',
                      style: TextStyle(
                        fontSize: 18,
                        color: mindfulBrown['Brown80'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}

class CustomSlider extends StatelessWidget {
  final int itemCount;
  final int selectedIndex;
  final Function(int) onSelected;

  const CustomSlider({
    Key? key,
    required this.itemCount,
    required this.onSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 300,
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            double dx = details.localPosition.dx;
            double sliderWidth = box.size.width;
            int newIndex = (dx / (sliderWidth / itemCount))
                .clamp(0, itemCount - 1)
                .toInt();
            onSelected(newIndex);
          }
        },
        child: CustomPaint(
          size: Size(double.infinity, 100),
          painter: SliderPainter(
            itemCount: itemCount,
            selectedIndex: selectedIndex,
          ),
        ),
      ),
    );
  }
}

class SliderPainter extends CustomPainter {
  final int itemCount;
  final int selectedIndex;

  SliderPainter({required this.itemCount, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double circleRadius = 15;
    double innerCircleRadius = 5;
    double arcHeight = height / 2; // Adjust arc height for a convex shape
    double spacing = width / (itemCount - 1);
    double lineSpacing = 8; // Space between the lines and the circles

    Paint linePaint = Paint()..strokeWidth = 10;

    Paint unselectedCirclePaint = Paint()..style = PaintingStyle.fill;

    Paint selectedCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Paint innerCirclePaint = Paint();

    // Define a function to get the color for the selected and previous circles
    Color getColor(int index) {
      switch (index) {
        case 0:
          return kindPurple['Purple30']!;
        case 1:
          return empathyOrange['Orange30']!;
        case 2:
          return mindfulBrown['Brown30']!;
        case 3:
          return zenYellow['Yellow30']!;
        case 4:
          return serenityGreen['Green30']!;
        default:
          return optimisticGray['Gray30']!;
      }
    }

    Color getDarkerColor(int index) {
      switch (index) {
        case 0:
          return kindPurple['Purple50']!;
        case 1:
          return empathyOrange['Orange50']!;
        case 2:
          return mindfulBrown['Brown50']!;
        case 3:
          return zenYellow['Yellow50']!;
        case 4:
          return serenityGreen['Green50']!;
        default:
          return optimisticGray['Gray50']!;
      }
    }

    // Function to calculate the convex arc's Y position
    double getArcY(double x) {
      double normalizedX =
          (x - width / 2) / (width / 2); // Normalize X to range [-1, 1]
      return arcHeight *
          (1 - normalizedX * normalizedX); // Concave parabolic equation
    }

    // Draw the connecting lines
    for (int i = 0; i < itemCount - 1; i++) {
      double startX = i * spacing + circleRadius + lineSpacing;
      double endX = (i + 1) * spacing - circleRadius - lineSpacing;
      double startY = height / 2 + getArcY(startX);
      double endY = height / 2 + getArcY(endX);

      linePaint.color = i < selectedIndex
          ? getColor(selectedIndex)
          : getDarkerColor(selectedIndex);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        linePaint,
      );
    }

    // Draw the circles
    for (int i = 0; i < itemCount; i++) {
      double centerX = i * spacing;
      double centerY = height / 2 + getArcY(centerX);
      Offset center = Offset(centerX, centerY);

      if (i <= selectedIndex) {
        // Apply the selected or inherited color
        Color color = getColor(selectedIndex);
        borderPaint.color = color;
        innerCirclePaint.color = color;

        // Draw selected or inherited circle with a border
        canvas.drawCircle(center, 20, selectedCirclePaint);
        canvas.drawCircle(center, 20, borderPaint);
      } else {
        // Draw unselected circle
        Color darkerColor = getDarkerColor(selectedIndex);
        unselectedCirclePaint.color = darkerColor;
        innerCirclePaint.color = getColor(selectedIndex);

        canvas.drawCircle(center, circleRadius, unselectedCirclePaint);
        canvas.drawCircle(center, innerCircleRadius, innerCirclePaint);
      }

      // Draw the inner circle for all circles
      canvas.drawCircle(center, innerCircleRadius, innerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
