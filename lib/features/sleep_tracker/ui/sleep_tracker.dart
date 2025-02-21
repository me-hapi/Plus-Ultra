import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/sleep_tracker/data/supabase.dart';
import 'package:lingap/features/sleep_tracker/ui/sleep_modal.dart';

class SleepTracker extends StatefulWidget {
  const SleepTracker({Key? key}) : super(key: key);

  @override
  _SleepTrackerState createState() => _SleepTrackerState();
}

class _SleepTrackerState extends State<SleepTracker> {
  final SupabaseDB supabase = SupabaseDB(client);
  double sleepHours = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'How many hours did you sleep?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 36,
                  color: mindfulBrown['Brown80'],
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 300,
            width: 300,
            child: CircularSleepSlider(
              value: sleepHours,
              onChanged: (newValue) {
                setState(() {
                  sleepHours = newValue;
                });
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await supabase.insertOrUpdatesleep(sleepHours);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SleepModal(sleepHours: sleepHours);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mindfulBrown['Brown80'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Set Mood',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      )),
    );
  }
}

class CircularSleepSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CircularSleepSlider({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CircularSleepSliderState createState() => _CircularSleepSliderState();
}

class _CircularSleepSliderState extends State<CircularSleepSlider> {
  double angle = pi / 2; // Start at bottom (6 o'clock)

  @override
  void initState() {
    super.initState();
    angle = _valueToAngle(widget.value);
  }

  double _valueToAngle(double value) {
    return (value - 1) / 11 * 2 * pi; // Normalize to 0 - 2π range
  }

  double _angleToValue(double angle) {
    double normalized = angle / (2 * pi);
    return (normalized * 11 + 1).clamp(1, 12);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset center = box.size.center(Offset.zero);
        Offset touchPosition = box.globalToLocal(details.globalPosition);
        double newAngle = atan2(
          touchPosition.dy - center.dy,
          touchPosition.dx - center.dx,
        );
        if (newAngle < 0) newAngle += 2 * pi; // Keep angle positive

        setState(() {
          angle = newAngle;
          widget.onChanged(_angleToValue(angle).round().toDouble());
        });
      },
      child: CustomPaint(
        size: const Size(300, 300),
        painter: CircularSliderPainter(angle, widget.value),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value.toInt().toString(),
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: mindfulBrown['Brown80'],
                ),
              ),
              Text(
                "Hours",
                style: TextStyle(fontSize: 20, color: optimisticGray['Gray40']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularSliderPainter extends CustomPainter {
  final double angle;
  final double value;

  CircularSliderPainter(this.angle, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset.zero);
    double radius = size.width / 2 - 10;

    Paint trackPaint = Paint()
      ..color = optimisticGray['Gray50']!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = _getGradientForValue(value)
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    // Draw track
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress
    double startAngle = -pi / 2; // Start from top
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      angle,
      false,
      progressPaint,
    );

    // Draw thumb
    Offset thumbPosition = Offset(
      center.dx + radius * cos(angle - pi / 2),
      center.dy + radius * sin(angle - pi / 2),
    );

    canvas.drawCircle(
      thumbPosition,
      15,
      Paint()..color = _getThumbColor(value),
    );
  }

  Color _getThumbColor(double value) {
    if (value <= 2) {
      return kindPurple['Purple50']!;
    } else if (value >= 3 && value <= 4) {
      return empathyOrange['Orange50']!;
    } else if (value == 5) {
      return mindfulBrown['Brown50']!;
    } else if (value >= 6 && value <= 7) {
      return zenYellow['Yellow50']!;
    } else {
      return serenityGreen['Green50']!;
    }
  }

  /// Returns a gradient based on sleep hours value
  LinearGradient _getGradientForValue(double value) {
    if (value <= 2) {
      return LinearGradient(
          colors: [kindPurple['Purple30']!, kindPurple['Purple70']!]);
    } else if (value >= 3 && value <= 4) {
      return LinearGradient(
          colors: [empathyOrange['Orange30']!, empathyOrange['Orange70']!]);
    } else if (value == 5) {
      return LinearGradient(
          colors: [mindfulBrown['Brown30']!, mindfulBrown['Brown70']!]);
    } else if (value >= 6 && value <= 7) {
      return LinearGradient(
          colors: [zenYellow['Yellow30']!, zenYellow['Yellow70']!]);
    } else {
      return LinearGradient(
          colors: [serenityGreen['Green30']!, serenityGreen['Green70']!]);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
