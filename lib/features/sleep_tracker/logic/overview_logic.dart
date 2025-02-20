import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/sleep_tracker/data/supabase.dart';
import 'package:lingap/core/const/colors.dart';

class OverviewLogic {
  final SupabaseDB supabase = SupabaseDB(client);
  Map<int, int> sleepData = {};
  int weeksleep = 0;

  List<Map<String, dynamic>> sleepSelection = [
    {
      'sleep': 'cheerful',
      'value': 5,
      'color': serenityGreen['Green50'],
      'image': 'assets/tracker/darkGreen.png',
      'icon': 'assets/whiteMoods/whiteGreen.png'
    },
    {
      'sleep': 'happy',
      'value': 4,
      'color': zenYellow['Yellow40'],
      'image': 'assets/tracker/darkYellow.png',
      'icon': 'assets/whiteMoods/whiteYellow.png'
    },
    {
      'sleep': 'neutral',
      'value': 3,
      'color': mindfulBrown['Brown50'],
      'image': 'assets/tracker/darkBrown.png',
      'icon': 'assets/whiteMoods/whiteBrown.png'
    },
    {
      'sleep': 'sad',
      'value': 2,
      'color': empathyOrange['Orange40'],
      'image': 'assets/tracker/darkOrange.png',
      'icon': 'assets/whiteMoods/whiteOrange.png'
    },
    {
      'sleep': 'awful',
      'value': 1,
      'color': kindPurple['Purple40'],
      'image': 'assets/tracker/darkPurple.png',
      'icon': 'assets/whiteMoods/whiteBlue.png'
    },
  ];

  String getDayLabel(int weekday) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return dayLabels[weekday - 1];
  }

  Future<void> fetchsleepData() async {
    List<Map<String, dynamic>> sleeps = await supabase.getPastWeeksleeps();

    Map<String, int> sleepIndexes = {
      "cheerful": 0,
      "happy": 1,
      "neutral": 2,
      "sad": 3,
      "awful": 4,
    };

    Map<int, int> sleepCount = {};
    sleepData.clear();

    for (var sleep in sleeps) {
      int weekday = DateTime.parse(sleep['created_at']).weekday;
      int sleepIndex = sleepIndexes[sleep['sleep'].toString().toLowerCase()] ?? -1;
      if (sleepIndex >= 0) {
        sleepData[weekday] = sleepIndex;
        sleepCount[sleepIndex] = (sleepCount[sleepIndex] ?? 0) + 1;
      }
    }

    weeksleep = sleepCount.entries.isNotEmpty
        ? sleepCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 0;
  }
}