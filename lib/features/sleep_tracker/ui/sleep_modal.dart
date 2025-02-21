import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';

class SleepModal extends StatelessWidget {
  final double sleepHours;

  SleepModal({required this.sleepHours});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> sleepData = getSleepData(sleepHours);

    return GestureDetector(
      onTap: () {
        context.go('/bottom-nav');
      },
      child: Container(
        child: Center(
          child: Container(
            width: 350,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/tracker/sleep_success.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  sleepData['title'],
                  style:
                      TextStyle(fontSize: 24, color: mindfulBrown['Brown80']),
                ),
                SizedBox(height: 8),
                Text(
                  sleepData['message'],
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 18, color: optimisticGray['Gray50']),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: mindfulBrown['Brown80'],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: TextButton(
                    onPressed: () {
                      context.go('/bottom-nav');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Go to Home',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Determines sleep quality based on hours slept
  Map<String, dynamic> getSleepData(double sleepHours) {
    if (sleepHours >= 7 && sleepHours <= 9) {
      return {
        'title': 'Excellent Sleep!',
        'message': 'You had a great rest. Keep up the good sleep habits!',
        'image': 'assets/sleep/excellent.png',
      };
    } else if (sleepHours >= 6 && sleepHours < 7) {
      return {
        'title': 'Good Sleep!',
        'message': 'You got a decent amount of rest. Try to aim for more!',
        'image': 'assets/sleep/good.png',
      };
    } else if (sleepHours == 5) {
      return {
        'title': 'Fair Sleep',
        'message': 'You might need a bit more rest for optimal energy.',
        'image': 'assets/sleep/fair.png',
      };
    } else if (sleepHours >= 3 && sleepHours < 5) {
      return {
        'title': 'Poor Sleep',
        'message': 'Your sleep could be better. Try improving your routine.',
        'image': 'assets/sleep/poor.png',
      };
    } else {
      return {
        'title': 'Worst Sleep',
        'message': 'You had very little rest. Consider prioritizing sleep.',
        'image': 'assets/sleep/worst.png',
      };
    }
  }
}
