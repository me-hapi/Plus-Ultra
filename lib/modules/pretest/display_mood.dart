import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class DisplayMood extends StatefulWidget {
  final Function(String)
      onMoodSelected; // Callback to pass the mood to the parent

  const DisplayMood({Key? key, required this.onMoodSelected}) : super(key: key);

  @override
  _DisplayMoodState createState() => _DisplayMoodState();
}

class _DisplayMoodState extends State<DisplayMood> {
  final List<String> moods = [
    "Awful",
    "Sad",
    "Neutral",
    "Happy",
    "Cheerful",
  ];

  final List<String> emojiPaths = [
    'assets/mood/awful.png',
    'assets/mood/sad.png',
    'assets/mood/neutral.png',
    'assets/mood/happy.png',
    'assets/mood/cheerful.png',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50,),
        Text(
          "I feel ${moods[selectedIndex]}",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        Image.asset(
          emojiPaths[selectedIndex],
          height: 100,
        ),
        SizedBox(height: 80),
        CustomSlider(
          itemCount: moods.length,
          onSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
            widget.onMoodSelected(moods[index]);
          },
          selectedIndex: selectedIndex,
        ),
      ],
    );
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

    Paint linePaint = Paint()
      ..strokeWidth = 10;

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
          ? getDarkerColor(selectedIndex)
          : getColor(selectedIndex);

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
        Color color = getDarkerColor(selectedIndex);
        borderPaint.color = color;
        innerCirclePaint.color = color;

        // Draw selected or inherited circle with a border
        canvas.drawCircle(center, circleRadius, selectedCirclePaint);
        canvas.drawCircle(center, circleRadius, borderPaint);
      } else {
        // Draw unselected circle
        Color darkerColor = getColor(selectedIndex);
        unselectedCirclePaint.color = darkerColor;
        innerCirclePaint.color = getDarkerColor(selectedIndex);

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
