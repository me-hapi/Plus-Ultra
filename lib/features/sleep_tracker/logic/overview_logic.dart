import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/sleep_tracker/data/supabase.dart';
import 'package:lingap/core/const/colors.dart';

class OverviewLogic {
  final SupabaseDB supabase = SupabaseDB(client);
  double avgSleep = 0.0;
  double sleepDebt = 0.0;
  int sleepIndex = 0;

  List<Map<String, dynamic>> sleepSelection = [
    {
      'sleep': 'excellent',
      'color': serenityGreen['Green50'],
      'image': 'assets/tracker/darkGreen.png',
      'icon': 'assets/whiteMoods/whiteGreen.png'
    },
    {
      'sleep': 'good',
      'color': zenYellow['Yellow40'],
      'image': 'assets/tracker/darkYellow.png',
      'icon': 'assets/whiteMoods/whiteYellow.png'
    },
    {
      'sleep': 'fair',
      'color': mindfulBrown['Brown50'],
      'image': 'assets/tracker/darkBrown.png',
      'icon': 'assets/whiteMoods/whiteBrown.png'
    },
    {
      'sleep': 'poor',
      'color': empathyOrange['Orange40'],
      'image': 'assets/tracker/darkOrange.png',
      'icon': 'assets/whiteMoods/whiteOrange.png'
    },
    {
      'sleep': 'worst',
      'color': kindPurple['Purple40'],
      'image': 'assets/tracker/darkPurple.png',
      'icon': 'assets/whiteMoods/whiteBlue.png'
    },
  ];

  Future<void> fetchSleepData() async {
    try {
      List<Map<String, dynamic>> pastWeekSleep = await supabase.getPastWeeksleeps();
      
      if (pastWeekSleep.isNotEmpty) {
        double totalSleep = pastWeekSleep.fold(0.0, (sum, row) => sum + (row['sleep_hour'] ?? 0.0));
        avgSleep = totalSleep / pastWeekSleep.length;
      } else {
        avgSleep = 0.0;
      }

      double recommendedSleep = 8.0; // Recommended sleep hours per day
      sleepDebt = (recommendedSleep - avgSleep) * pastWeekSleep.length;
      sleepDebt = sleepDebt < 0 ? 0 : sleepDebt; // Ensure sleepDebt is not negative

      if (avgSleep >= 7 && avgSleep <= 9) {
        sleepIndex = 0;
      } else if (avgSleep >= 6 && avgSleep < 7) {
        sleepIndex = 1;
      } else if (avgSleep == 5) {
        sleepIndex = 2;
      } else if (avgSleep >= 3 && avgSleep <= 4) {
        sleepIndex = 3;
      } else {
        sleepIndex = 4;
      }

      print('Average Sleep: $avgSleep hours');
      print('Sleep Debt: $sleepDebt hours');
      print('Sleep Index: $sleepIndex');
    } catch (e) {
      print('Error fetching sleep data: $e');
    }
  }
}
